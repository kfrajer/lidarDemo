import processing.core.*;

class LidarDataPackage {

  static final int N=4;  //Number of readings  
  static final int PKG_SIZE=22;
  final String SEP="\t";

  static final int ID=1;
  static final int CHKSUM_L=20;
  static final int CHKSUM_H=21;
  
  PApplet pa;

  byte[] rawData;

  long time;
  int id;
  int[] speed;
  boolean[] invalidFlag;
  boolean[] strengthWarning;
  int[] distance;
  int[] signalStrength;

  //CONSTRUCTOR
  LidarDataPackage(PApplet p,byte[] in, long ctime) {

    pa=p;
    id=-1;
    speed=new int[N] ;
    invalidFlag=new boolean[N];
    strengthWarning=new boolean[N];
    distance=new int[N];
    signalStrength=new int[N];

    time=ctime;
    rawData=in;
    extractData();
  }

  void extractData() {

    //Map your raw data into proper fields in this class
    //To be implemented
    
    id=rawData[ID];
  }

  @Override
    public String toString() {
    String ss="";
    ss+="Package report\n";
    ss+="==============\n";
    ss+="ID: 0x"+pa.hex(id,2) +"\n";
    ss+="Time: "+time +"\n";
    ss+="i"+ SEP +"Dista"+ SEP + "Strength" + "\n";
    for (int i=0; i<N; i++)
      ss+=i+ SEP +distance[i]+ SEP +signalStrength[i] +"\n";
    return ss;
  }


  public static boolean verifyPackageIntegrity(byte[] in) {
    boolean valid=false;

    if (in==null || in.length!=PKG_SIZE)
      return valid;

    //... PERFORM check sum validation
    //To be implemented

    int checkSum=(in[CHKSUM_H]<<8)+in[CHKSUM_L];
    if (checkSum!=0)  //CheckSum to be implemented properly
      valid=true;

    return valid;
  }
}