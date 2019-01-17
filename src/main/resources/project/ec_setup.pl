my %VSBuild = (
    label       => "Visual Studio - Execute VSBuild Task",
    procedure   => "VSBuild",
    description => "Execute Visual Studio task such build, rebuild, clean or deploy",
    category    => "Build"
);

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-VisualStudio - VSBuild");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Visual Studio - Execute VSBuild Task");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/VisualStudio - Execute VSBuild Task");

@::createStepPickerSteps = (\%VSBuild);
