package com.incheck.ng.webapp.action;

import static com.incheck.ng.model.ChannelType.DYNAMIC;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.apache.commons.io.IOUtils;
import org.springframework.context.ApplicationContext;

import com.incheck.ng.Constants;
import com.incheck.ng.dao.ChannelDao;
import com.incheck.ng.dsp.DSPCalculator;
import com.incheck.ng.model.Channel;
import com.incheck.ng.model.data.RawData;
import com.incheck.ng.webapp.ApplicationContextProvider;
/**
 * Samples file upload action
 */
public class FileUploadAction extends BaseAction {
    private static final long serialVersionUID = -9208910183310010569L;
    private static final String JSON_SAMPLING_RATE = "sampling-rate";
    private static final String JSON_CHANNEL_ID = "channel-id";
    private static final String JSON_DATA = "data";
    private File file;
    private String fileContentType;
    private String fileFileName;

    /**
     * Upload the file
     *
     * @return String with result (cancel, input or sucess)
     * @throws Exception if something goes wrong
     */
    public String upload() throws Exception {
        if (this.cancel != null) {
            return "cancel";
        }
        InputStream stream = new FileInputStream(file);
        String jsonTxt = IOUtils.toString(stream);
        JSONObject json = (JSONObject) JSONSerializer.toJSON(jsonTxt);
        long channelId = json.getLong(JSON_CHANNEL_ID);
        int samplingRate = json.getInt(JSON_SAMPLING_RATE);
        JSONArray jsonArray = json.getJSONArray(JSON_DATA);
        int[] data = new int[jsonArray.size()];
        for (int j = 0; j < jsonArray.size(); j++) {
            data[j] = jsonArray.getInt(j);
        }
        RawData rawData = new RawData(channelId, samplingRate, data);
        ApplicationContext context = ApplicationContextProvider.getApplicationContext();
        ChannelDao channelDao = (ChannelDao) context.getBean("channelDao");
        Channel channel = channelDao.get(channelId);
        DSPCalculator calculator = (DSPCalculator) context.getBean(DYNAMIC == channel.getChannelType() ? "dynamicCalculator"
                : "staticCalculator");
        calculator.processData(rawData);

        // place the data into the request for retrieval on next page
        getRequest().setAttribute("location", Constants.FILE_SEP + fileFileName);
        String link = getRequest().getContextPath() + "/resources" + "/" + getRequest().getRemoteUser() + "/";
        getRequest().setAttribute("link", link + fileFileName);
        return SUCCESS;
    }

    /**
     * Default method - returns "input"
     *
     * @return "input"
     */
    public String execute() {
        return INPUT;
    }

    public void setFile(File file) {
        this.file = file;
    }

    public void setFileContentType(String fileContentType) {
        this.fileContentType = fileContentType;
    }

    public void setFileFileName(String fileFileName) {
        this.fileFileName = fileFileName;
    }

    public File getFile() {
        return file;
    }

    public String getFileContentType() {
        return fileContentType;
    }

    public String getFileFileName() {
        return fileFileName;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void validate() {
        if (getRequest().getMethod().equalsIgnoreCase("post")) {
            getFieldErrors().clear();
            if ("".equals(fileFileName) || file == null) {
                super.addFieldError("file", getText("errors.requiredField", new String[] {getText("uploadForm.file")}));
            } else if (file.length() > 2097152) {
                addActionError(getText("maxLengthExceeded"));
            }
        }
    }
}
