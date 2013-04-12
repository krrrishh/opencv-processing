import gab.opencvpro.*;
import org.opencv.core.Mat;
import org.opencv.calib3d.StereoBM;
import org.opencv.core.CvType;
import org.opencv.calib3d.StereoSGBM;

OpenCVPro ocvL, ocvR;
PImage  imgL, imgR, depth1, depth2;

void setup() {

  imgL = loadImage("scene_l.jpg");
  imgR = loadImage("scene_r.jpg");
  ocvL = new OpenCVPro(this, imgL);

  ocvR = new OpenCVPro(this, imgR);

  size(ocvL.width * 2, ocvL.height*2);

  ocvL.gray();
  ocvR.gray();
  Mat left = ocvL.getBufferGray();
  Mat right = ocvR.getBufferGray();

  Mat disparity = OpenCVPro.imitate(left);

  StereoSGBM stereo =  new StereoSGBM(0, 32, 3, 128, 256, 20, 16, 1, 100, 20, true);
  stereo.compute(left, right, disparity );

  Mat depthMat = OpenCVPro.imitate(left);
  disparity.convertTo(depthMat, depthMat.type());

  depth1 = createImage(depthMat.width(), depthMat.height(), RGB);
  ocvL.toPImage(depthMat, depth1);

  StereoBM stereo2 = new StereoBM();
  stereo2.compute(left, right, disparity );
  disparity.convertTo(depthMat, depthMat.type());


  depth2 = createImage(depthMat.width(), depthMat.height(), RGB);
  ocvL.toPImage(depthMat, depth2);
}

void draw() {
  image(imgL, 0, 0);
  image(imgR, imgL.width, 0);

  image(depth1, 0, imgL.height);
  image(depth2, imgL.width, imgL.height);

  fill(255, 0, 0);
  text("left", 10, 20);
  text("right", 10 + imgL.width, 20);
  text("stereo SGBM", 10, imgL.height + 20);
  text("stereo BM", 10 + imgL.width, imgL.height+ 20);
}

