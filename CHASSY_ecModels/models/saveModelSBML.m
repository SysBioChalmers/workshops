%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% model = saveECmodelSBML(model,name,isBatch)
%
% Benjam?n J. S?nchez. Last edited: 2018-08-22
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function saveModelSBML(model,name,isEC)

%Introduce compartments to both metabolite ID and name:
comps     = model.comps;
compNames = model.compNames;
for i = 1:length(model.mets)
    comp_ID           = comps{model.metComps(i)};
    comp_name         = compNames{model.metComps(i)};
    model.mets{i}     = [model.mets{i} '[' comp_ID ']'];
    model.metNames{i} = [model.metNames{i} ' [' comp_name ']'];
end
model = rmfield(model,'metComps');
%Format gene rule field:
difference = length(model.grRules)-length(model.rules);
lastRule = length(model.rules);
if difference>0
    model.rules(lastRule+1:end+difference) = model.grRules(lastRule+1:end);
end

%Format metFormulas:
model.metFormulas = strrep(model.metFormulas,'(','');
model.metFormulas = strrep(model.metFormulas,')n','');
model.metFormulas = strrep(model.metFormulas,')','');

if isEC
    cd ecGEMs
else
    cd GEMs
end

%Save model:
writeCbModel(model,'sbml',[name '.xml']);
writeCbModel(model,'text',[name '.txt']);

%Convert notation "e-005" to "e-05 " in stoich. coeffs. to avoid
%inconsistencies between Windows and MAC:
copyfile([name '.xml'],'backup.xml')
fin  = fopen('backup.xml', 'r');
fout = fopen([name '.xml'], 'w');
still_reading = true;
while still_reading
  inline = fgets(fin);
  if ~ischar(inline)
      still_reading = false;
  else
      if ~isempty(regexp(inline,'-00[0-9]','once'))
          inline = strrep(inline,'-00','-0');
      elseif ~isempty(regexp(inline,'-01[0-9]','once'))
          inline = strrep(inline,'-01','-1');
      end
      fwrite(fout, inline);
  end
end
fclose('all');
delete('backup.xml');

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%