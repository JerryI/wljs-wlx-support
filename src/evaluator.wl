PacletRepositories[{
}, "Directory"->ParentDirectory[DirectoryName[$InputFileName]], "Passive"->True]

<<JerryI`WLX`
<<JerryI`WLX`Importer`
<<JerryI`WLX`WLJS`

JerryI`WolframJSFrontend`Evaluator`WLXEvaluator[str_String, signature_, type_:String][callback_] := Module[{},
  Block[{$CellUid = CreateUUID[]},
   With[{res = ProcessString[str, "Localize"->True] // ReleaseHold},     
    callback[
      If[ListQ[res], StringRiffle[Map[ToString, Select[res, (# =!= Null)&]], ""], ToString[res]],
      $CellUid, 
      type,
      Null
    ];
   ];
  ]
];