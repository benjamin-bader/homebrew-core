class Cdrdao < Formula
  desc "Record CDs in Disk-At-Once mode"
  homepage "http://cdrdao.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cdrdao/cdrdao/1.2.3/cdrdao-1.2.3.tar.bz2"
  sha256 "8193cb8fa6998ac362c55807e89ad0b3c63edc6b01afaeb3d5042519527fb75e"

  bottle do
    sha256 "69c67458aa6f7f0e843a1760606336433e68735c3d1030a463dd7a3c7692e79a" => :sierra
    sha256 "bf776ba977bbafbe32c21ae77174cc18a0af3639dd25d845d5f2a18b50b12555" => :el_capitan
    sha256 "2f0ce2699c25a6586d2532a17a46e6643a94ddbf9da5e77f9aaf326da1a0b692" => :yosemite
    sha256 "01e1dde5119c810802b5abfcbc30da6e02b35bb721cbfff83604f1e5aebd22e7" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "lame"

  # first patch fixes build problems under 10.6
  # see https://sourceforge.net/p/cdrdao/patches/23/
  patch do
    url "https://sourceforge.net/p/cdrdao/patches/_discuss/thread/205354b0/141e/attachment/cdrdao-mac.patch"
    sha256 "ee1702dfd9156ebb69f5d84dcab04197e11433dd823e80923fd497812041179e"
  end

  # second patch fixes device autodetection on macOS
  # see https://trac.macports.org/ticket/27819
  # upstream bug report:
  # https://sourceforge.net/p/cdrdao/bugs/175/
  patch :p0, :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end

__END__
--- dao/main.cc	2013-11-26 12:00:00.000000000 -0400
+++ dao/main.cc	2013-11-26 12:00:00.000000000 -0400
@@ -1242,7 +1242,7 @@
 const char* getDefaultDevice(DaoDeviceType req)
 {
     int i, len;
-    static char buf[128];
+    static char buf[1024];
 
     // This function should not be called if the command issues
     // doesn't actually require a device.
@@ -1270,7 +1270,7 @@
 	    if (req == NEED_CDRW_W && !rww)
 	      continue;
 
-	    strncpy(buf, sdata[i].dev.c_str(), 128);
+	    strncpy(buf, sdata[i].dev.c_str(), 1024);
 	    delete[] sdata;
 	    return buf;
 	}
