PacletRepositories[{
    Github -> "https://github.com/JerryI/wl-wlx" -> "dev"
}, "Directory" -> FileNameJoin[{Directory[], "__localkernel", "wlx-support"}] ];

BeginPackage["Notebook`Editor`WLXTools`", {
    "JerryI`Notebook`Kernel`", 
    "JerryI`Notebook`Transactions`",
    "JerryI`Misc`Events`",
    "JerryI`WLX`",
    "JerryI`WLX`Importer`"
}];

Begin["`Private`"]

Notebook`WLXEvaluator = Function[t, 
            With[{result = ProcessString[t["Data"], "Localize"->False]  // ReleaseHold},
                With[{string = If[ListQ[result], StringRiffle[Map[ToString, Select[result, (# =!= Null)&]], ""], ToString[result] ]},
                    EventFire[Internal`Kernel`Stdout[ t["Hash"] ], "Result", <|"Data" -> string, "Meta" -> Sequence["Display"->"wlx"] |> ];
                    EventFire[Internal`Kernel`Stdout[ t["Hash"] ], "Finished", True];
                ];
            ];
];


ExpressionReplacements = {
    Graphics[opts__] :> Global`CreateFrontEndObject[Graphics[opts]], 
    Graphics3D[opts__] :> Global`CreateFrontEndObject[Graphics3D[opts]], 
    Image[opts__] :> Global`CreateFrontEndObject[Image[opts]]
};

JerryI`WLX`Private`IdentityTransform[EventObject[assoc_]] := If[KeyExistsQ[assoc, "view"], Global`CreateFrontEndObject[ assoc["view"]], EventObject[assoc] ]
JerryI`WLX`Private`IdentityTransform[x_] := x /. ExpressionReplacements

ListLinePlotly /: JerryI`WLX`Private`IdentityTransform[ListLinePlotly[args__]] := Global`CreateFrontEndObject[ListLinePlotly[args]]
ListPlotly /: JerryI`WLX`Private`IdentityTransform[ListPlotly[args__]] := Global`CreateFrontEndObject[ListPlotly[args]]

End[]

EndPackage[]



