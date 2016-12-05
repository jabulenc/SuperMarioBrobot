-- 7 Class Problem
require 'nn'
--require 'cudnn'
require 'torch'

-- Image size: 256x224x3
-- SMB apparent Sprite: 16x16
-- NES Supported Sprites: 8x8, 8x16
-- Floor dims (I think): 24x16

--------------------------------------------------------------------------------
-- Recursive routine that restore a saved net for further training
--------------------------------------------------------------------------------

-- Repopulate the gradWeight through the whole net
function craftWeight(module)
   if module.weight then module.gradWeight = module.weight:clone() end
   if module.bias   then module.gradBias   = module.bias  :clone() end
   module.gradInput  = torch.Tensor()
end

function repopulateGrad(network)
   craftWeight(network)
   if network.modules then
      for _,a in ipairs(network.modules) do
         repopulateGrad(a)
      end
   end
end

------

local model
if opt.load == "" then

model = nn.Sequential();

-- Stage 1
model:add(nn.SpatialConvolution(3,64,32,32,8,8,2,2));
model:add(nn.ReLU(true));
model:add(nn.SpatialMaxPooling(3,3,2,2));

-- Stage 2
model:add(nn.SpatialConvolution(64,128,16,16,4,4,2,2));
model:add(nn.ReLU(true));
model:add(nn.SpatialMaxPooling(3,3,2,2));

-- Stage 3
model:add(nn.SpatialConvolution(128,256,8,8,2,2,1,1));
model:add(nn.ReLU(true));
-- Final Stage
model:add(nn.View(256))
model:add(nn.Linear(256, 128))
model:add(nn.Linear(128, 2))
model:add(nn.LogSoftMax())


else
      print(sys.COLORS.red ..  "==> loading existing network")
      model = torch.load(opt.load)
      repopulateGrad(model)
end
loss = nn.ClassNLLCriterion()

return {
   model = model,
   loss = loss,
}