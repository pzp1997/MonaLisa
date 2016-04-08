import gab.opencv.OpenCV;
import processing.video.Capture;
import java.awt.Rectangle;

PImage monaLisa;
Capture cam;
OpenCV faceCascade;
Rectangle[] faces;
Rectangle monaLisaFace, liveFace;

void setup() {
  size(512, 624);

  // PImage of the Mona Lisa
  monaLisa = loadImage("Mona_Lisa.jpg");
  
  // Select and initialize the webcam
  cam = new Capture(this, 640, 480, "Live! Cam Sync HD VF0770");
  cam.start();
  
  // Setup the face detection object
  faceCascade = new OpenCV(this, monaLisa.width, monaLisa.height);
  faceCascade.loadCascade(OpenCV.CASCADE_FRONTALFACE);

  // Detect the Mona Lisa's face and store Rectangle of it in `monaLisaFace`
  faceCascade.loadImage(monaLisa);
  monaLisaFace = findLargestFace(faceCascade.detect());
  
  // Set default drawing options
  noFill();
  strokeWeight(5);
}

void draw() {
  // Read image from webcam
  if (cam.available()) {
    cam.read();
  }

  // Detect the faces in the live image
  faceCascade.loadImage(cam);
  faces = faceCascade.detect();
  liveFace = scaleRectangle(findLargestFace(faces), cam.width, cam.height, width, height);
  
  // Display the live image
  image(cam, 0, 0, width, height);

  // Display red boxes around all of the faces
  stroke(255, 0, 0);
  for (Rectangle face : faces) {
    face = scaleRectangle(face, cam.width, cam.height, width, height);
    rect(face.x, face.y, face.width, face.height);
  }
  
  // Display a green box around *the* face (determined by largest area)
  stroke(0, 255, 0);
  rect(liveFace.x, liveFace.y, liveFace.width, liveFace.height);

  //image(monaLisa, 0, 0, width/2, height);
  //rect(monaLisaFace.x, monaLisaFace.y, monaLisaFace.width, monaLisaFace.height);
  //copy(cam,
  //     liveFace.x, liveFace.y, liveFace.width, liveFace.height,
  //     monaLisaFace.x, monaLisaFace.y, monaLisaFace.width, monaLisaFace.height);
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

Rectangle scaleRectangle(Rectangle r, float w1, float h1, float w2, float h2) {
  int x = (int) map(r.x, 0, w1, 0, w2), 
      y = (int) map(r.y, 0, h1, 0, h2), 
      w = (int) map(r.width, 0, w1, 0, w2), 
      h = (int) map(r.height, 0, h1, 0, h2);
      
  return new Rectangle(x, y, w, h);
}