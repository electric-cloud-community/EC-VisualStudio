# -------------------------------------------------------------------------
# Package
#    visualstudioDriver.pl
#
# Dependencies
#    None
#
# Purpose
#    Use Visual Studio tool features on Electric Commander
#
# Plugin Version
#    1.0.1
#
# Date
#    04/18/2011
#
# Engineer
#    Andres Arias
#
# Copyright (c) 2011 Electric Cloud, Inc.
# All rights reserved
# -------------------------------------------------------------------------


# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use Cwd;
use strict;
use warnings;
use ElectricCommander;
$|=1;

# -------------------------------------------------------------------------
# Variables
# -------------------------------------------------------------------------

################################################################################
# procedure parameter name: [devenvExecutable]
#
# script variable name: $::gDevenvExecutable
#
# purpose: the Visual Studio executable
#
# implemented in this script: yes
################################################################################

################################################################################
# procedure parameter name: [workingDirectory]
#
# script variable name: $::gWorkingDirectory
#
# purpose: the directory to change to before executing Visual Studio
#
# implemented in this script: yes
################################################################################

################################################################################
# procedure parameter name: [solutionFile]
#
# script variable name: $::gSolutionFile
#
# purpose: specify the solution file to load
#
# implemented in this script: yes
################################################################################

################################################################################
# procedure parameter name: [target]
#
# script variable name: $::gCommand
#
# purpose: specify the target to execute
#
# implemented in this script: yes
################################################################################

################################################################################
# procedure parameter name: [solutionConfiguration]
#
# script variable name: $::gSolutionConfiguration
#
# purpose: specify the solution configuration to build
#
# implemented in this script: yes
################################################################################

################################################################################
# procedure parameter name: [projectFile]
#
# script variable name: $::gProjectFile
#
# purpose: specify the project file to load
#
# implemented in this script: yes
################################################################################

################################################################################
# procedure parameter name: [projectConfiguration]
#
# script variable name: $::gProjectConfiguration
#
# purpose: specify the project configuration to build
#
# implemented in this script: yes
################################################################################

################################################################################
# procedure parameter name: [useenv]
#
# script variable name: $::gUseenv
#
# purpose: instructs Visual Studio to use the environment for PATH etc.
#
# implemented in this script: yes
################################################################################

my $ec = ElectricCommander->new();
$ec->abortOnError(0);

$::gDefaultDevenvExec     = "devenv";
$::gDevenvExecutable      = ($ec->getProperty( "devenvExecutable" ))->findvalue('//value')->string_value;
$::gWorkingDirectory      = ($ec->getProperty( "workingDir" ))->findvalue('//value')->string_value;
$::gSolutionFile          = ($ec->getProperty( "solutionFile" ))->findvalue('//value')->string_value;
$::gAction                = ($ec->getProperty( "action" ))->findvalue('//value')->string_value;
$::gSolutionConfiguration = ($ec->getProperty( "solutionConfiguration" ))->findvalue('//value')->string_value;
$::gProjectFile           = ($ec->getProperty( "projectFile" ))->findvalue('//value')->string_value;
$::gProjectConfiguration  = ($ec->getProperty( "projectConfiguration" ))->findvalue('//value')->string_value;
$::gUseenv                = ($ec->getProperty( "useenv" ))->findvalue('//value')->string_value;


# -------------------------------------------------------------------------
# Main functions
# -------------------------------------------------------------------------

########################################################################
# createVisualStudioCommandLine - creates the command line for the invocation
# of devenv.
#
# Arguments:
#   -arr: array containing arguments entered by the user in the UI
#
# Returns:
#   -the command line to be executed by the plugin
#
########################################################################
sub createVisualStudioCommandLine {

    my ($arr) = @_;

    my $command = '';

    if($::gDevenvExecutable && $::gDevenvExecutable ne '') {
        $command = qq{"$::gDevenvExecutable"};
    } else {
        $command .= $::gDefaultDevenvExec;
    }
    
    foreach my $elem (@$arr) {
        $command .= " $elem";
    }
    
    return $command;
}

########################################################################
# setProperties - set a group of properties into the Electric Commander
#
# Arguments:
#   -propHash: hash containing the ID and the value of the properties 
#              to be written into the Electric Commander
#
# Returns:
#   -nothing
#
########################################################################
sub setProperties {

    my ($propHash) = @_;

    # get an EC object
    my $ec = new ElectricCommander();
    $ec->abortOnError(0);

    foreach my $key (keys % $propHash) {
        my $val = $propHash->{$key};
        $ec->setProperty("/myCall/$key", $val);
    }
}


########################################################################
# main - contains the whole process to be done by the plugin, it builds
#        the command line, sets the properties and the working directory
#
# Arguments:
#   none
#
# Returns:
#   none
#
########################################################################
sub main {
    
    # create args array
    my @args = ();
    my %props;	

    # if solutionFile: add to command string
    if($::gSolutionFile && $::gSolutionFile ne '') {
        push(@args, qq{"$::gSolutionFile"});
    }

    # if command: add to command string
    if($::gAction && $::gAction ne '') {
        push(@args, $::gAction);
    }

    # if solutionConfiguration: add to command string
    if($::gSolutionConfiguration && $::gSolutionConfiguration ne '') {
        push(@args, qq{"$::gSolutionConfiguration"});
    }

    # if projectFile: add to command string
    if($::gProjectFile && $::gProjectFile ne '') {
        push(@args, qq{/project "$::gProjectFile"});

        # if projectConfiguration: add to command string
        if($::gProjectConfiguration && $::gProjectConfiguration ne '') {
            push(@args, qq{/projectconfig "$::gProjectConfiguration"});
        }
    }

    push(@args, qq{/Out "$[jobId]_log.txt"});
    
    registerReports("$[jobId]_log.txt");
    
    # if useenv: add to command string
    if($::gUseenv && $::gUseenv ne '') {
        push(@args, '/useenv');
    }

    my $copycmd = "";
    my $currentPath = cwd;
    if($::gWorkingDirectory && $::gWorkingDirectory ne ""){
        if($^O eq "linux"){
            $copycmd = qq{cp $[jobId]_log.txt "$currentPath"};
        }else{
            $copycmd = qq{copy $[jobId]_log.txt "$currentPath"};
        }
    }
    
    $props{'copycommand'} = $copycmd;
    $props{'visualstudioCommandLine'} = createVisualStudioCommandLine(\@args);
    $props{'workingDir'} = $::gWorkingDirectory;
    
    setProperties(\%props);
}

########################################################################
# registerReports - creates a link for registering the generated report
# in the job step detail
#
# Arguments:
#   -none
#
# Returns:
#   -nothing
#
########################################################################
sub registerReports{
 
    # get an EC object
    my $ec = new ElectricCommander();
    $ec->abortOnError(0);
    my $OutFile = shift;
    if($OutFile && $OutFile ne ""){
        $ec->setProperty("/myJob/artifactsDirectory", '');
        $ec->setProperty("/myJob/report-urls/Out File", "jobSteps/$[jobStepId]/" . "$OutFile");  
    }

}

main();

