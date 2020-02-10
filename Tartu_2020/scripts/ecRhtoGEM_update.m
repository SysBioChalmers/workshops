% ecRhtoGEMUpdate
%
%   Ivan Domenzain, 2020-02-07
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
delete databases/prot_abundance.txt
GECKOver = git('describe --tags');
cd geckomat/get_enzyme_data
updateDatabases;
cd ..
[ecModel,ecModel_batch] = enhanceGEM(model,'COBRA','ecRhtoGEM',modelVer);
cd ../..

%Move model files:
rmdir('model', 's')
movefile GECKO/models/ecRhtoGEM model
save('model/ecRhtoGEM.mat','ecModel')
save('model/ecRhtoGEM.mat','ecModel_batch')

%Save associated versions:
fid = fopen('dependencies.txt','wt');
fprintf(fid,['GECKO\t' GECKOver '\n']);
fprintf(fid,['yeast-GEM\t' modelVer '\n']);
fclose(fid);

%Remove the cloned repos:
rmdir('GECKO', 's')
rmdir('ecRhtoGEM', 's')
