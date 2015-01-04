
///////////////////////////////////////////////////
//                                               //
//                                               //
//               PHOTO BOOTH                     //
//                                               //
//                                               //
///////////////////////////////////////////////////

// (c) Martin Schneider 2014

//   Just a quick processing sketch to take
//   photos of  all participants of the course


import processing.video.Capture;
import controlP5.ControlP5;
import controlP5.Textfield;

Capture cam;
PImage snap;
PFont font;
ControlP5 cp5;

// camera dimensions
int w = 320, h = 240;

// gui dimensions
int border = 12;
int hgui = 50;
int fontSize = 14;

// gui tabbing
int tabCount = 1;

// output folder
File folder;


Textfield nameField, mailField;

void setup() {
  
  // window size depending on camera dimensions
  size(w * 2 + 3 * border, h + hgui + 2 * border);
  
  // set everything up
  font = createFont("Arial", fontSize);
  cam = new Capture(this, w, h);
  snap = createImage(w, h, RGB);
  cam.start();
  setupGui();
   
  // ask for target folder when the program starts
  selectFolder("Select a folder for images:", "folderSelected");

  // drawing style for boxes
  stroke(255, 100);
  noFill();
  
}

void setupGui() {

  cp5 = new ControlP5(this);
  
  int hfield = hgui - border - 8;
  int wbutton = hfield;
  int wfield1 = w;
  int wfield2 = w - border - wbutton;
 
  int px = border + 1 ;
  int py = h + 2 * border;
  
  nameField = cp5.addTextfield("Name")
     .setPosition(px, py)
     .setSize(wfield1, hfield)
     .setFont(font)
     .setFocus(true)
     ;
     
   px += wfield1 + border;
   mailField = cp5.addTextfield("Email")
     .setPosition(px, py)
     .setSize(wfield2 , hfield)
     .setFont(font)
     ;
     
   px += wfield2 + border;
   cp5.addButton("snap")
     .setPosition(px, py)
     .setSize(wbutton , hfield)
     ;
      
}


// draw live image + snapshot
void draw() {
  
  background(#002233);
  
  image(cam, border, border);
  rect(border, border, w, h);
  
  image(snap, 2 * border + w, border);
  rect(2 * border + w, border, w, h);
  
}


// callback for reading a new from the camera when it's available
void captureEvent(Capture c) {
  c.read();
}


// callback for selecting the target directory
void folderSelected(File selection) {
  if(selection != null) {
    folder = selection;
  } else {
    // quit program if no folder was selected
    exit();
  }
}


// create a snapshot and save it
void snap() {
  
  snap = cam.get();
  
  String filename = nameField.getText() + " <" + mailField.getText() + ">.jpg";
  File file = new File(folder, filename);
  
  String filepath = file.getAbsolutePath();
  println("Savig snapshot to " + filepath);
  
  snap.save(filepath);
  
}


// let the user toggle focus between fields with the tab key
void keyPressed() {
  if (keyCode == TAB) {    
    tabCount = 1 - tabCount;
    if(tabCount == 0) {
      mailField.setFocus(false); 
      nameField.setFocus(true); 
    } else {
      nameField.setFocus(false);
      mailField.setFocus(true);
    }
  }
}




