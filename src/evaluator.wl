PacletRepositories[{
}, "Directory"->ParentDirectory[DirectoryName[$InputFileName]], "Passive"->True]

<<JerryI`WLX`
<<JerryI`WLX`Importer`
<<JerryI`WLX`WLJS`

JerryI`WolframJSFrontend`Evaluator`WLXEvaluator[str_String, signature_, type_:String, opts___][callback_] := With[{$CellUid = CreateUUID[]},
  Block[{EvaluationCell = Function[Null, $CellUid]},
   With[{res = (ProcessString[str, "Localize"->False, opts]  // ReleaseHold)},     
    callback[
      If[ListQ[res], StringRiffle[Map[ToString, Select[res, (# =!= Null)&]], ""], ToString[res]],
      $CellUid, 
      type,
      Null
    ];
   ];
  ]
];


JerryI`WLX`Private`IdentityTransform[EventObject[assoc_]] := If[KeyExistsQ[assoc, "view"], CreateFrontEndObject[assoc["view"]], EventObject[assoc]]
JerryI`WLX`Private`IdentityTransform[x_] := x /. JerryI`WolframJSFrontend`WebObjects`replacement 
