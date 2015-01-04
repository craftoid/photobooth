(* ::Package:: *)

(* ::Title:: *)
(*PhotoBooth*)


(* ::Text:: *)
(*Just a quick sketch to take pics with iSight camera and a photobooth interface*)
(* *)


(* ::Section:: *)
(*Code*)


(* ::Subsection:: *)
(*iSight Snapshot*)


(* ::Text:: *)
(*The iSight camera needs some warm-up time ...*)


snapshot[delay_:0.1] := Block[
	{dev,img},
	dev = DeviceOpen["Camera"];
	Pause[delay]; 
	img = CurrentImage[];
	DeviceClose[dev]; 
	img
]


(* ::Subsection:: *)
(*PhotoBooth*)


(* ::Text:: *)
(*PhotoBooth App for taking pics of our students*)


photoBooth[] := DynamicModule[

	{
		liveimg ,
		resetData, saveData, savePic,capturePic,
		enableCam,disableCam,
		name, email,snapimg ,
		cameraOn = False,
		picTaken = False,
		dev
	},

	resetData[] := (snapimg= "Your Photo"; name=""; email="");
	capturePic[] := (snapimg=Image[ IMAQTools`CameraCaptureFrame[] / 255, ImageSize->All]; picTaken = True);
	savePic[] := (Export[name <> " <" <> email <> ">.jpg", snapimg]; picTaken = False);
	enableCam[] := (dev = DeviceOpen["Camera"]; cameraOn = True);
	disableCam[] := (liveimg =""; DeviceClose[dev]; cameraOn = False);

	liveimg = Dynamic[If[cameraOn,CurrentImage[ImageSize-> All],Pane["",{320,240}]]];

	resetData[];

	Panel[

		Grid[

			{

				{
					Pane[Style["Camera","Subsection"], {320,50}, Alignment->{Center,Center}],
					Pane[Style["Photo","Subsection"], {320,50}, Alignment->{Center,Center}],
					Pane[Style["Profile","Subsection"], {320,50}, Alignment->{Center,Center}]
				},

				{
					liveimg, 
					Dynamic @ snapimg,
					Column[{
						Row[{"Name",InputField[Dynamic[name],String, ImageSize->250]},Spacer[10]],
						Spacer[10],
						Row[{"Email",InputField[Dynamic[email],String, ImageSize->250]},Spacer[10]]
					}]
				},

				{ 
					Dynamic[
						If[cameraOn,
							Button["Turn Off",disableCam[], ImageSize->{320,50}],
							Button[Style["Turn On",Bold], enableCam[], ImageSize->{320,50}]
						]
					],
					Dynamic[Button["Take Snapshot", capturePic[], ImageSize->{320,50}, Enabled->cameraOn]],
					Dynamic[Button["Save Data", (savePic[]; resetData[]),  ImageSize->{320,50}, Enabled-> picTaken]]
				}

			},

			Frame-> All,
			FrameStyle->{Thickness[1], GrayLevel[.8]},
			Spacings->{1,1}
		]

	]

]





(* ::Section:: *)
(*Apps*)


(* ::Subsubsection:: *)
(*Launch PhotoBooth*)


photoBooth[]


(* ::Subsubsection:: *)
(*Take a Snapshot*)


(*snapshot[]*)
