BeginPackage["Notebook`Editor`WLXTools`", {
    "JerryI`Notebook`Kernel`", 
    "JerryI`Notebook`Transactions`",
    "JerryI`Misc`Events`",
    "JerryI`WLX`",
    "JerryI`WLX`Importer`",
    "Notebook`Editor`FrontendObject`"
}];

Begin["`Private`"]

Notebook`WLXEvaluator = Function[t,  With[{hash = CreateUUID[]},
        Block[{Global`$EvaluationContext = Join[t["EvaluationContext"], <|"ResultCellHash" -> hash|>]},
            With[{result = ProcessString[t["Data"], "Localize"->False]  // ReleaseHold},
                With[{string = If[ListQ[result], StringRiffle[Map[ToString, Select[result, (# =!= Null)&]], ""], ToString[result] ]},
                    EventFire[Internal`Kernel`Stdout[ t["Hash"] ], "Result", <|"Data" -> string, "Meta" -> Sequence["Display"->"wlx", "Hash"->hash] |> ];
                    EventFire[Internal`Kernel`Stdout[ t["Hash"] ], "Finished", True];
                ];
            ];
        ];
    ]
];

System`DatasetWrapper;

ExpressionReplacements = {
    Graphics[opts__] :> CreateFrontEndObject[Graphics[opts]], 
    Graphics3D[opts__] :> CreateFrontEndObject[Graphics3D[opts]], 
    Image[opts__] :> CreateFrontEndObject[Image[opts]],
    s_Sound :> CreateFrontEndObject[s],
    d_Dataset :> DatasetWrapper[d]
} // Quiet;


(*JerryI`WLX`Private`IdentityTransform[EventObject[assoc_]] := If[KeyExistsQ[assoc, "View"], CreateFrontEndObject[ assoc["View"]], EventObject[assoc] ]*)
EventObject /: MakeBoxes[EventObject[assoc_], WLXForm] := If[KeyExistsQ[assoc, "View"],
    With[{o = CreateFrontEndObject[assoc["View"]]},
        MakeBoxes[o, WLXForm]
    ]
,
    EventObject[assoc]
]

JerryI`WLX`Private`IdentityTransform[x_] := ToBoxes[x /. ExpressionReplacements, WLXForm]


End[]

EndPackage[]



