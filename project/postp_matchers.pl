
push (@::gMatchers,
  {
   id =>        "notRecognized",
   pattern =>          q{(.+)is not recognized as an internal or external command},
   action =>           q{
    
              my $description = ((defined $::gProperties{"summary"}) ? 
                    $::gProperties{"summary"} : '');
                    
              $description .= "An error ocurred: $1 is not recognized as an internal or external command";
                              
              setProperty("summary", $description . "\n");
    
   },
  },
  {
   id =>        "version",
   pattern =>          q{Microsoft \(R\) Visual Studio (.+)},
   action =>           q{
    
              my $description = ((defined $::gProperties{"summary"}) ? 
                    $::gProperties{"summary"} : '');
                    
              $description .= "Visual Studio $1";
                              
              setProperty("summary", $description . "\n");                     
    
   },
  },
  {
   id =>        "results",
   pattern =>          q{=+ (.+) =+},
   action =>           q{
    
              my $description = ((defined $::gProperties{"summary"}) ? 
                    $::gProperties{"summary"} : '');

              $description .= "$1";
                              
              setProperty("summary", $description . "\n");    
    
   },
  },
  {
   id =>        "actionInfo",
   pattern =>          q{-+ (.+) started:(.+) -+},
   action =>           q{
    
              my $description = ((defined $::gProperties{"summary"}) ? 
                    $::gProperties{"summary"} : '');
                    
              $description .= "Action: $1, $2";
                              
              setProperty("summary", $description . "\n");    
    
   },
  },
  {
   id =>        "errorDesc",
   pattern =>          q{All rights reserved.\s{4}(.+)},
   action =>           q{
    
              my $description = ((defined $::gProperties{"summary"}) ? 
                    $::gProperties{"summary"} : '');
                    
              $description .= "An error occured: $1";
                              
              setProperty("summary", $description . "\n");    
    
   },
  },
{
   id =>        "errorDescInvalid",
   pattern =>          q{^Invalid(.+)},
   action =>           q{
    
              my $description = ((defined $::gProperties{"summary"}) ? 
                    $::gProperties{"summary"} : '');
                    
              $description .= "Invalid$1";
                              
              setProperty("summary", $description . "\n");    
    
   },
  }, 
{
   id =>        "errorDescNotCompleted",
   pattern =>          q{The operation could not be completed.(.+)},
   action =>           q{
    
              my $description = ((defined $::gProperties{"summary"}) ? 
                    $::gProperties{"summary"} : '');
                    
              $description .= "The operation could not be completed: $1";
                              
              setProperty("summary", $description . "\n");    
    
   },
  },   
  {
   id =>        "fileSelected",
   pattern =>          q{The selected file(.+)},
   action =>           q{
    
              my $description = ((defined $::gProperties{"summary"}) ? 
                    $::gProperties{"summary"} : '');
                    
              $description .= "The selected file$1";
                              
              setProperty("summary", $description . "\n");    
    
   },
  }  
);
