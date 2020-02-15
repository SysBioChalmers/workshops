% ecRhtoGEMUpdate
%
%   Ivan Domenzain, 2020-02-15
%

%Clone the necessary repos:
git('clone https://github.com/SysBioChalmers/GECKO.git')
cd GECKO
git('pull')
%Locate the correct branch
git('checkout fix/updateDatabases') 
%Load rhto model:
cd ..
git('clone https://github.com/SysBioChalmers/rhto-GEM.git')
model    = load('rhto-GEM/ModelFiles/mat/rhto.mat');
model    = model.model;
modelVer = model.description(strfind(model.description,'_v')+1:end);
%If there's no prot_abundance.txt file in the provided databases, then
%remove this file from GECKO/databases in order to assume a f factor of 0.5
if ~isfile('../databases/prot_abundance.txt')
    delete('GECKO/databases/prot_abundance.txt')
end
%Replace scripts in GECKO:
for fileType={'rhto_scripts' '../databases'}
fileNames = dir(fileType{1});
for i = 1:length(fileNames)
    fileName = fileNames(i).name;
    if ~ismember(fileName,{'.' '..' '.DS_Store'})
        fullName   = [fileType{1}  '/' fileName];
        GECKO_path = dir(['GECKO/**/' fileName]);
        GECKO_path = GECKO_path.folder;
        copyfile(fullName,GECKO_path)
    end
end
end

%Run GECKO pipeline:
cd GECKO
GECKOver = git('describe --tags');
cd geckomat/get_enzyme_data
updateDatabases;
cd ..
[ecModel,ecModel_batch] = enhanceGEM(model,'COBRA','ecRhtoGEM',modelVer);
cd ../..

%Move model files:
mkdir('../models/ecRhtoGEM')
movefile GECKO/models/ecRhtoGEM ../models/ecRhtoGEM
save('../models/ecRhtoGEM/ecRhtoGEM.mat','ecModel')
save('../models/ecRhtoGEM/ecRhtoGEM_batch.mat','ecModel_batch')

%Save associated versions:
fid = fopen('dependencies.txt','wt');
fprintf(fid,['GECKO\t' GECKOver '\n']);
fprintf(fid,['rhto-GEM\t' modelVer '\n']);
fclose(fid);

%Remove the cloned repos:
rmdir('GECKO', 's')
rmdir('rhto-GEM', 's')
