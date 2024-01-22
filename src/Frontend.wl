BeginPackage["Notebook`Editor`WLXProcessor`", {
    "JerryI`Notebook`", 
    "JerryI`Notebook`Evaluator`", 
    "JerryI`Notebook`Kernel`", 
    "JerryI`Notebook`Transactions`",
    "JerryI`Misc`Events`"
}]

Begin["`Internal`"]

Q[t_Transaction] := ( StringMatchQ[t["Data"], ".wlx"~~___] )

rootFolder = $InputFileName // DirectoryName;

evaluator  = StandardEvaluator["Name" -> "WLX Evaluator", "InitKernel" -> init, "Pattern" -> (_?Q), "Priority"->(9)];

    StandardEvaluator`ReadyQ[evaluator, k_] := (
        If[! TrueQ[k["ReadyQ"] ] || ! TrueQ[k["ContainerReadyQ"] ],
            EventFire[k, "Error", "Kernel is not ready"];
            StandardEvaluator`Print[evaluator, "Kernel is not ready"];
            False
        ,
            (* load kernels stuff. i.e. do it on demand, otherwise it takes too long on the startup *)
            (*With[{p = Import[FileNameJoin[{rootFolder, "Preload.wl"}], {"Package", "HeldExpressions"}]},
              Kernel`Init[k,  ReleaseHold /@ p; , "Once"->True];
            ];*)
            With[{p = Import[FileNameJoin[{rootFolder, "Preload.wl"}], "String"]},
                Kernel`Init[k,   ToExpression[p, InputForm]; , "Once"->True];
            ];

            True
        ]
    );

StandardEvaluator`Evaluate[evaluator, k_, t_] := Module[{list},
    t["Evaluator"] = Notebook`WLXEvaluator;
    t["Data"] = StringDrop[t["Data"], 5];

    StandardEvaluator`Print[evaluator, "Kernel`Submit!"];
    Kernel`Submit[k, t];    
];  

init[k_] := Module[{},
    Print["nothing to do..."];
]


End[]

EndPackage[]