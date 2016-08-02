package com.slava.tests.workspace_save;

import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class EclipseProjectsSaver {
    private final static String SAVE_FOLDER = "C:/dev/temp/eclipse_save";
    private final static String SVN_TRUNK_FOLDER = "C:/dev/svnroot/skc/branches/RB-SKC-17.4"; // "C:/dev/svnroot/skc/trunk";

    public EclipseProjectsSaver() {
    }

    public static void main(String[] args) throws IOException {
        // saveEclipseProjects(SVN_TRUNK_FOLDER, SAVE_FOLDER);
        restoreEclipseProjects(SVN_TRUNK_FOLDER, SAVE_FOLDER);
    }

    private static void saveEclipseProjects(String skcRoot, String destinationDir) throws IOException {
        destinationDir = ensureTrailingSlash(destinationDir);
        File[] projectDirs = new File(skcRoot).listFiles(new FileFilter() {
            public boolean accept(File pathname) {
                return pathname.isDirectory();
            }
        });
        for (File projectDir : projectDirs) {
            File[] eclipseFiles = projectDir.listFiles(new FileFilter() {
                public boolean accept(File pathname) {
                    return pathname.getName().equals(".project") || pathname.getName().equals(".classpath");
                }
            });
            for (File eclipseFile : eclipseFiles) {
                copyFile(eclipseFile, new File(destinationDir + projectDir.getName() + eclipseFile.getName()));
            }
        }
    }

    private static void restoreEclipseProjects(String skcRoot, String destinationDir) throws IOException {
        File[] eclipseFiles = new File(destinationDir).listFiles(new FileFilter() {
            public boolean accept(File pathname) {
                return pathname.getName().endsWith(".project") || pathname.getName().endsWith(".classpath");
            }
        });
        skcRoot = ensureTrailingSlash(skcRoot);
        for (File eclipseFile : eclipseFiles) {
            String parts[]  = eclipseFile.getName().split("[.]");
            copyFile(eclipseFile, new File(skcRoot+parts[0]+"/."+parts[1]));
        }
    }

    private static void copyFile(File src, File dst) throws IOException {
        InputStream in = new FileInputStream(src);
        OutputStream out = new FileOutputStream(dst); // Transfer bytes from in
                                                      // to out
        byte[] buf = new byte[1024];
        int len;
        while ((len = in.read(buf)) > 0) {
            out.write(buf, 0, len);
        }
        in.close();
        out.close();
    }

    private static String ensureTrailingSlash(String path) {
        return (path.endsWith("\\") || path.endsWith("/")) ? path : path + "/";
    }
}
