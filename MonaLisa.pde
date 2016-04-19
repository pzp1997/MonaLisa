import gab.opencv.OpenCV;
import processing.video.Capture;
import java.awt.Rectangle;

PImage monaLisa, mask, maskedFace;
Capture cam;
OpenCV faceCascade;
Rectangle[] faces;
Rectangle monaLisaFace, liveFace;

void setup() {  
  // Load PImage of the Mona Lisa
  monaLisa = loadImage("Mona_Lisa.jpg");

  // Set the size of the canvas according to the dimensions of `monaLisa`
  surface.setSize(monaLisa.width, monaLisa.height);

  // Select and initialize the webcam
  cam = new Capture(this, 640, 480, "Live! Cam Sync HD VF0770");
  try {
    cam.start();
  } 
  catch (NullPointerException e) {
    cam = new Capture(this, 640, 480);
    cam.start();
  }

  // Detect the Mona Lisa's face and store Rectangle of it in `monaLisaFace`
  faceCascade = new OpenCV(this, monaLisa.width, monaLisa.height);
  faceCascade.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  faceCascade.loadImage(monaLisa);
  monaLisaFace = findLargestFace(faceCascade.detect());

  // Setup the face detection object
  faceCascade = new OpenCV(this, cam.width, cam.height);
  faceCascade.loadCascade(OpenCV.CASCADE_FRONTALFACE);

  mask = loadImage("mask.png");

  // Set default drawing options
  noFill();
  strokeWeight(5);
}

void draw() {
  // Read image from webcam
  if (cam.available()) {
    cam.read();
  }

  // Display the Mona Lisa
  image(monaLisa, 0, 0, width, height);

  // Detect the faces in the live image
  faceCascade.loadImage(cam);
  faces = faceCascade.detect();
  
  // If there is a detected face...
  if (faces.length > 0) {
    // Find the largest detected face (by area)
    liveFace = findLargestFace(faces);
    
    // Mask the face with an ellipse to remove background in corners
    mask.resize(liveFace.width, liveFace.height);
    maskedFace = new PImage(liveFace.width, liveFace.height);
    maskedFace.copy(cam, liveFace.x, liveFace.y, liveFace.width, liveFace.height, 
                    0, 0, maskedFace.width, maskedFace.height);
    maskedFace.mask(mask);

    // Insert *the* face on top of the Mona Lisa's face
    blend(maskedFace, 0, 0, maskedFace.width, maskedFace.height, 
          monaLisaFace.x, monaLisaFace.y, monaLisaFace.width, monaLisaFace.height, MULTIPLY);
  }
}

// Save the outputted picture when the mouse is pressed
void mousePressed() {
  // Save current canvas to sketch folder
  saveFrame();
  // "Flash" animation 
  background(255);
}

Rectangle findLargestFace(Rectangle[] faces) {
  Rectangle largestFace = new Rectangle();
  float maxArea = -1;
  float area;

  for (Rectangle face : faces) {
    area = face.width * face.height;
    if (area > maxArea) {
      largestFace = face;
      maxArea = area;
    }
  }

  return largestFace;
}