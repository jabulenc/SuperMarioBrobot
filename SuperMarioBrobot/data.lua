
require 'image'   -- to visualize the dataset
require 'ffmpeg'
require 'csvigo'

----------------------------------------------------------------------

function ls(path) return sys.split(sys.ls(path),'\n') end -- alf ls() nice function!

----------------------------------------------------------------------
-- load or generate new dataset:

if paths.filep('train.t7') 
   and paths.filep('test.t7') then

   print(sys.COLORS.red ..  '==> loading previously generated dataset:')
   trainData = torch.load('train.t7')
   testData = torch.load('test.t7')

   trSize = trainData.data:size(1)
   teSize = testData.data:size(1)

else

   print(sys.COLORS.red ..  '==> creating a new dataset from raw files:')

   
   local trainDir = '../FCEUX/testdata/'
   local trSize = #ls(trainDir)
   local testDir = '../FCEUX/evaldata/'
   local teSize = #ls(testDir)
   local trainMeta = csvigo.load{path=trainDir.."metadata.csv", mode = 'query'}
   local testMeta = csvigo.load{path=testDir.."metadata.csv", mode = 'query'}

   trainData = {
      data = torch.Tensor(trSize, 3, 256, 224),
      labels = torch.Tensor(trSize),
      size = function() return trSize end
   }

   -- shuffle dataset: get shuffled indices in this variable:
   local trShuffle = torch.randperm(trSize) -- train shuffle
   
   -- load person train data
   for i = 1, trSize, 1 do
      img = image.load(trainDir..i..".png",3,'byte') -- we pick all of the images in train!
      trainData.data[trShuffle[i]] = img:clone()
      trainData.labels[trShuffle[i]] = trainMeta('frame', {frame=i}).Input[1] -- gets the input string rep
   end
   -- display some examples:
   if opt.visualize then
       image.display{image=trainData.data[{{1,128}}], nrow=16, zoom=2, legend = 'Train Data'}
   end

   testData = {
      data = torch.Tensor(teSize, 3, 256, 224),
      labels = torch.Tensor(teSize),
      size = function() return teSize end
   }

   -- load person test data
   for i = 1, teSize, 1 do
      img = image.load(trainDir..i..".png",3,'byte') -- we pick all of the images in train!
      trainData.data[trShuffle[i]] = img:clone()
      trainData.labels[trShuffle[i]] = testMeta('frame', {frame=i}).Input[1] -- gets the input string rep
   end
   -- display some examples:
   if opt.visualize then
       image.display{image=testData.data[{{1,128}}], nrow=16, zoom=2, legend = 'Test Data'}
   end


   --save created dataset:
   torch.save('train.t7',trainData)
   torch.save('test.t7',testData)
end

-- Displaying the dataset architecture ---------------------------------------
print(sys.COLORS.red ..  'Training Data:')
print(trainData)
print()

print(sys.COLORS.red ..  'Test Data:')
print(testData)
print()

-- Preprocessing -------------------------------------------------------------
dofile 'preprocessing.lua'

trainData.size = function() return trSize end
testData.size = function() return teSize end


-- classes: GLOBAL var!
classes = {'ULAB','URAB', 'DLAB', 'DRAB',
            'UAB', 'DAB', 'LAB', 'RAB', 'UA',. 'UB', 'DA', 'DB', 'LA', 'LB'
            'RA', 'RB', 'U', 'D', 'L', 'R', 'A', 'B', ''}

-- Exports -------------------------------------------------------------------
return {
   trainData = trainData,
   testData = testData,
   mean = mean,
   std = std,
   classes = classes
}
