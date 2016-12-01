require 'nn'
require 'torch'
require 'image'

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

screen = torch.Tensor(3,256,224);
model = torch.load("results/model.net");
repopulateGrad(model);
screen = image.load("./cur.png",3,'float');
pred = model:forward(screen);
os.remove("./cur.png");
return {
math.exp(pred[1]),
math.exp(pred[2]),
math.exp(pred[3]),
math.exp(pred[4])
};
