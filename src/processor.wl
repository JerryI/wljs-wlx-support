PacletRepositories[{
    Github -> "https://github.com/JerryI/wl-wlx"
}, "Directory"->ParentDirectory[DirectoryName[$InputFileName]]]

BeginPackage["JerryI`WolframJSFrontend`WLXSupport`"];

Begin["Private`"];

WLXProcessor[expr_String, signature_String, parent_, callback_] := Module[{str = StringDrop[expr, StringLength[First[StringSplit[expr, "\n"]]] ]},
  Print["WLXProcessor!"];
  JerryI`WolframJSFrontend`Notebook`Notebooks[signature]["kernel"][JerryI`WolframJSFrontend`Evaluator`WLXEvaluator[str, signature, "wlx", parent], callback, "Link"->"WSTP"];
];

WLXQ[str_]      := Length[StringCases[StringSplit[str, "\n"] // First, RegularExpression["^\\.(wlx)$"]]] > 0;

JerryI`WolframJSFrontend`Notebook`NotebookAddEvaluator[(WLXQ      ->  <|"SyntaxChecker"->(True&),               "Epilog"->(#&),             "Prolog"->(#&), "Evaluator"->WLXProcessor       |>), "HighestPriority"];

End[];

EndPackage[];