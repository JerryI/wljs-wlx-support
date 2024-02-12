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


ExpressionReplacements = {
    Graphics[opts__] :> CreateFrontEndObject[Graphics[opts]], 
    Graphics3D[opts__] :> CreateFrontEndObject[Graphics3D[opts]], 
    Image[opts__] :> CreateFrontEndObject[Image[opts]]
};

JerryI`WLX`Private`IdentityTransform[EventObject[assoc_]] := If[KeyExistsQ[assoc, "View"], CreateFrontEndObject[ assoc["View"]], EventObject[assoc] ]
JerryI`WLX`Private`IdentityTransform[x_] := x /. ExpressionReplacements

ListLinePlotly /: JerryI`WLX`Private`IdentityTransform[ListLinePlotly[args__]] := CreateFrontEndObject[ListLinePlotly[args]]
ListPlotly /: JerryI`WLX`Private`IdentityTransform[ListPlotly[args__]] := CreateFrontEndObject[ListPlotly[args]]

End[]

EndPackage[]



