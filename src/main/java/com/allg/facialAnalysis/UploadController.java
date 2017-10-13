package com.allg.facialAnalysis;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;

import javax.annotation.Resource;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.allg.util.MediaUtils;
import com.allg.util.NaverClovaFaceRecognition;
import com.allg.util.UploadFileUtils;

@Controller
public class UploadController {

	@Resource(name = "uploadPath")
	public String uploadPath;
	
	private static final Logger logger = LoggerFactory.getLogger(UploadController.class);

	@ResponseBody
	@RequestMapping(value = "/uploadFile", method = RequestMethod.POST)
	public ResponseEntity<String> uploadFile(MultipartHttpServletRequest request) throws Exception {

		MultipartFile file = request.getFile("file");
		
		logger.info("originalName : " + file.getOriginalFilename());
		logger.info("size : " + file.getSize());
		logger.info("contentType : " + file.getContentType());

		String fileName = UploadFileUtils.uploadFile(uploadPath, file.getOriginalFilename(), file.getBytes());
		String result = NaverClovaFaceRecognition.searchCeleb(fileName, uploadPath);
		
		
		System.out.println(result);
		
		return new ResponseEntity<String>(result, HttpStatus.OK);
	}
	
	@ResponseBody
	@RequestMapping("/displayFile")
	public ResponseEntity<byte[]> displayFile(String fileName) throws Exception {

		InputStream in = null;
		ResponseEntity<byte[]> entity = null;

		logger.info("File Name : " + fileName);

		try {

			String formatName = fileName.substring(fileName.lastIndexOf(".") + 1); // 확장자 추출
			MediaType mType = MediaUtils.getMediaType(formatName);
			HttpHeaders headers = new HttpHeaders();

			System.out.println(formatName);
			System.out.println(uploadPath + fileName);

			in = new FileInputStream(uploadPath + fileName);

			if (mType != null) {
				headers.setContentType(mType);

			} else {
				// 이미지 파일이 아닌 경우
				fileName = fileName.substring(fileName.indexOf("_") + 1);
				headers.setContentType(MediaType.APPLICATION_OCTET_STREAM); // 다운로드 용
				headers.add("Content-Disposition",
						"attachment; filename=\"" + new String(fileName.getBytes("UTF-8"), "ISO-8859-1") + "\""); // 다운로드시
																													// 한글파일
																													// 인코딩처리
			}

			// 실제 데이터를 읽는 부분, commons 라이브러리의 IOUtils.toByteArray()
			entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);

		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
		} finally {
			in.close();
		}

		return entity;
	}
	
	@ResponseBody
	@RequestMapping(value = "/deleteFile", method = RequestMethod.POST)
	public ResponseEntity<String> deleteFile(String fileName) {

		logger.info("delete file: " + fileName);

		String formatName = fileName.substring(fileName.lastIndexOf(".") + 1);

		MediaType mType = MediaUtils.getMediaType(formatName);

		if (mType != null) {
			// 원본 사진 삭제
			String path = fileName.substring(0, 12);
			String name = fileName.substring(14);
			new File(uploadPath + (path + name).replace('/', File.separatorChar)).delete();
		}

		new File(uploadPath + fileName.replace('/', File.separatorChar)).delete();

		return new ResponseEntity<String>("deleted", HttpStatus.OK);
	}
}
