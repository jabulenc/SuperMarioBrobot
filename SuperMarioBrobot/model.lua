-- 26 Class Problem
require 'nn'
--require 'cudnn'
require 'torch'

-- Image size: 256x224x3
-- SMB apparent Sprite: 16x16
-- NES Supported Sprites: 8x8, 8x16
-- Floor dims (I think): 24x16

local CNN = nn.Sequential();

-- Stage 1
CNN:add(nn.SpatialConvolution(3,64,16,16,8,8,2,2));
CNN:add(nn.ReLU(true));
CNN:add(nn.SpatialMaxPooling(3,3,2,2));

-- Stage 2
CNN:add(nn.SpatialConvolution(64,128,8,8,4,4,2,2));
CNN:add(nn.ReLU(true));
CNN:add(nn.SpatialMaxPooling(3,3,2,2));

-- Stage 3
CNN:add(nn.SpatialConvolution(128,256,4,4,2,2,1,1));
CNN:add(nn.ReLU(true));
local classifier = nn.Sequential()
-- Final Stage
classifier:add(nn.View(opt.batchSize*256))
--classifier:add(nn.Dropout(0.5))
classifier:add(nn.Linear(opt.batchSize*256, 4096))
classifier:add(nn.Threshold(0, 1e-6))
classifier:add(nn.Dropout(0.5))
classifier:add(nn.Linear(4096, 1024))
classifier:add(nn.Threshold(0, 1e-6))
classifier:add(nn.Dropout(0.5))
classifier:add(nn.Linear(1024, 26))
classifier:add(nn.LogSoftMax())


local model = nn.Sequential()

model:add(CNN):add(classifier)
loss = nn.ClassNLLCriterion()

return {
   model = model,
   loss = loss,
}