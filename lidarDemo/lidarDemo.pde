//REFERENCE: https://forum.processing.org/two/discussion/26201/neato-lidar-sensor-and-reading-the-serial-data-and-making-sense-of-it#latest
//REFERENCE: Static: https://processing.org/reference/environment/index.html#Tabs


/*****INSTRUCTIONS
 *
 * This is a demonstration of how to process raw data from a lidar. 
 * The first part loads fake data to be used for testing the code
 * that loads and process this data.
 *
 * Right now noly one tet package is defined (1 out of 3) 
 * The processing module still needs to be implemented. Specifically both
 * verifyPackageIntegrity() and extractData() within LidarDataPackage class
 * 
 * Structure of a package described in post: https://forum.processing.org/two/discussion/26201/neato-lidar-sensor-and-reading-the-serial-data-and-making-sense-of-it#latest
 * 
 * After running the program, an array is generated with all extracted packages, which can be used for further processing or for dispalying. 
 */

final int N_PKG=3;  //Number of packages in test array

//This next contains test data as defined before 
byte[] testData;

byte[] current_package=new byte[LidarDataPackage.PKG_SIZE];
int indexRead=0;

ArrayList<LidarDataPackage> lidarData;

void setup() {
  size(600, 400);

  loadTestData();  
  lidarData=new ArrayList<LidarDataPackage>();
}

void draw() {

  boolean ready=readData();

  if (ready) {
    println("Full package detected. Now processing...");
    processData();
  }
}

boolean readData() {
  boolean readyToProcess=false;
  current_package[indexRead%LidarDataPackage.PKG_SIZE]=testData[indexRead];
  indexRead++;

  if (indexRead==LidarDataPackage.PKG_SIZE) {
    readyToProcess=true;
  }

  if (indexRead==LidarDataPackage.PKG_SIZE*N_PKG) 
    reportAndFinishDemo();

  return readyToProcess;
}


void processData() {

  //Here you need to check if the 22 bytes is proper by checking the check sum

  boolean valid=LidarDataPackage.verifyPackageIntegrity(current_package);

  //If check sum is good, retrieve every field.

  if (valid) {
    println("Valid data @" + indexRead);
    LidarDataPackage pkg=new LidarDataPackage(this,current_package, millis());
    lidarData.add(pkg);
    prepareToNextPackage();
  }
}

void prepareToNextPackage() {
  for (int i=0; i<LidarDataPackage.PKG_SIZE; i++) {
    current_package[i]=0x00;
  }
}

void reportAndFinishDemo() {

  //Print extracted valid data
  for (LidarDataPackage p : lidarData) {
    println(p.toString());
  }

  println("Normal termination. " + indexRead + " total number of bytes processed!");
  exit();
}

void loadTestData() {
  testData=new byte[LidarDataPackage.PKG_SIZE*N_PKG];

  //INIT all fields to zero
  for (int i=0; i<LidarDataPackage.PKG_SIZE*N_PKG; i++)
    testData[i]=byte(0x00);


  //Example defining a test package.
  testData[0]=byte(0xFA);   //Begin package 1 out of 3
  testData[1]=byte(0xA0);   //Index 0
  testData[2]=byte(0xFF);  //Speed_L
  testData[3]=byte(0x00);  //Speed_H
  testData[4]=byte(0x00);  //DATA1: distance 0:7
  testData[5]=byte(0x00);  //DATA1: invalid flag, strength warning, distance 15:8
  testData[6]=byte(0x00);  //DATA1: Signal strength 7:0
  testData[7]=byte(0x00);  //DATA1: Signal strength 15:8  
  testData[8]=byte(0x00);  //DATA2: distance 0:7
  testData[9]=byte(0x00);  //DATA2: invalid flag, strength warning, distance 15:8
  testData[10]=byte(0x00);  //DATA2: Signal strength 7:0
  testData[11]=byte(0x00);  //DATA2: Signal strength 15:8 
  testData[12]=byte(0x00);  //DATA3: distance 0:7
  testData[13]=byte(0x00);  //DATA3: invalid flag, strength warning, distance 15:8
  testData[14]=byte(0x00);  //DATA3: Signal strength 7:0
  testData[15]=byte(0x00);  //DATA3: Signal strength 15:8 
  testData[16]=byte(0x00);  //DATA4: distance 0:7
  testData[17]=byte(0x00);  //DATA4: invalid flag, strength warning, distance 15:8
  testData[18]=byte(0x00);  //DATA4: Signal strength 7:0
  testData[19]=byte(0x00);  //DATA4: Signal strength 15:8 
  testData[20]=byte(0x01);  //checksum_L
  testData[21]=byte(0x00);  //checksum_H
  //===============================
  // NOW defining next test package
  testData[22]=byte(0xFA); //Begin package 2 out of 3
  //testData[23]=...
  //...
  //... To be defined
  //...
  //===============================
  // NOW defining next test package
  testData[43]=byte(0xFA); //Begin package 3 out of 3
  //...
  //... To be defined
  //...
}