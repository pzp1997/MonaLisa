import gab.opencv.OpenCV;
import processing.video.Capture;
import java.awt.Rectangle;

PImage monaLisa;
Capture cam;
OpenCV faceCascade;
Rectangle[] faces;
Rectangle monaLisaFace, liveFace;

void setup() {
  float wid, hgt, scale;
  
  monaLisa = loadImage("Mona_Lisa_smaller.jpg");
  
  scale = 1;
  wid = monaLisa.width * scale;
  hgt = monaLisa.height * scale;
  
  faceCascade = new OpenCV(this, monaLisa.width, monaLisa.height);
  faceCascade.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  
  faceCascade.loadImage(monaLisa);
  faces = faceCascade.detect();
  monaLisaFace = findLargestFace(faces);
  
//  println(Capture.list());
  cam = new Capture(this, 640, 480);
  cam.start();
  
  size((int) wid * 2, (int) hgt);
  noFill();
  stroke(255, 0, 0);
  strokeWeight(5);
  
  image(monaLisa, 0, 0, width/2, height);
  rect(monaLisaFace.x * scale, monaLisaFace.y * scale, monaLisaFace.width * scale, monaLisaFace.height * scale);
}

void draw() {
  if (cam.available()) {
    cam.read();
  }
  
  faceCascade.loadImage(cam);
  faces = faceCascade.detect();
  liveFace = findLargestFace(faces);
  
   println(liveFace);
  
  image(cam, width/2, 0, width, height);
  rect(width - liveFace.x, liveFace.y, liveFace.width, liveFace.height);
  
  
//  copy(cam,
//       liveFace.x, liveFace.y, liveFace.width, liveFace.height,
//       monaLisaFace.x, monaLisaFace.y, monaLisaFace.width, monaLisaFace.height);
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
