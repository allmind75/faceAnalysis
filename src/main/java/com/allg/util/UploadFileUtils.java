package com.allg.util;

import java.io.File;
import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.FileCopyUtils;

public class UploadFileUtils {

	private static final Logger logger = LoggerFactory.getLogger(UploadFileUtils.class);

	public static String uploadFile(String uploadPath, String originalName, byte[] fileData) throws Exception {

		// UUID 생성 -> UUID + 파일이름 -> 파일저장할 /년/월/일 폴더 생성 -> 파일저장
		UUID uid = UUID.randomUUID();
		String savedName = uid.toString() + "_" + originalName;
		String savedPath = calcPath(uploadPath); // 저장할 경로 년/월/일

		File target = new File(uploadPath + savedPath, savedName);

		FileCopyUtils.copy(fileData, target); // 원본 파일 저장

		String uploadedFileName = null;

		uploadedFileName = makeIcon(uploadPath, savedPath, savedName);

		return uploadedFileName;
	}

	private static String calcPath(String uploadPath) {
		// 현재 년/월/일 로 경로 설정
		Calendar cal = Calendar.getInstance();

		// File.separator -> 파일 구분자 '\'
		String yearPath = File.separator + cal.get(Calendar.YEAR);
		String monthPath = yearPath + File.separator + new DecimalFormat("00").format(cal.get(Calendar.MONTH) + 1);
		String datePath = monthPath + File.separator + new DecimalFormat("00").format(cal.get(Calendar.DATE));

		makeDir(uploadPath, yearPath, monthPath, datePath);

		logger.info(datePath);

		return datePath;
	}

	private static void makeDir(String uploadPath, String... paths) {

		// dataPath 경로 있는지 확인, 경로 있으면 리턴
		if (new File(paths[paths.length - 1]).exists()) {
			return;
		}
		for (String path : paths) {
			File dirPath = new File(uploadPath + path);

			if (!dirPath.exists()) {
				// 경로에 폴더생성
				dirPath.mkdirs();
			}
		}
	}

	private static String makeIcon(String uploadPath, String path, String fileName) throws Exception {

		String iconName = uploadPath + path + File.separator + fileName;

		return iconName.substring(uploadPath.length()).replace(File.separatorChar, '/');
	}
}
