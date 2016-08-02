/**
 * 
 */
package com.inchecktech.dpm.network.parser;

import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import com.inchecktech.dpm.beans.TreeNode;
import com.inchecktech.dpm.network.parser.JsonFieldNameConstants.DAM_MESSAGE_TYPE;

/**
 * JSON parser implementation of <code>DPMParser</code> interface
 * 
 * @author Slava Kovalenko
 * 
 */
public class JSONConverter implements DPMParser {
    public static String toJson(int protocolVersion, IncomingData data) {
        JSONObject dataJson = new JSONObject();
        dataJson.element(JsonFieldNameConstants.PROTOCOL_VERSION, 2).element(JsonFieldNameConstants.MESSAGE_TYPE, DAM_MESSAGE_TYPE.DATA).element(
                JsonFieldNameConstants.DEVICE_ID, data.getDeviceId()).element(JsonFieldNameConstants.TIMESTAMP, System.currentTimeMillis()).element(
                JsonFieldNameConstants.DEVICE_CHANNEL_ID, data).element(JsonFieldNameConstants.SAMPLE_SIZE, data.getSamplingSize()).element(
                JsonFieldNameConstants.DATA, protocolVersion == 2 ? data.getByteData() : data.getDoubleData()).element(JsonFieldNameConstants.SAMPLING_RATE,
                data.getSamplingRate()).element(JsonFieldNameConstants.RPM, data.getRpm()).element(JsonFieldNameConstants.UNIT, data.getUnit());
        return dataJson.toString();
    }

    public static DamMessage fromJson(String jsonTxt) {
        DamMessage returnValue = null;
        JSONObject json = (JSONObject) JSONSerializer.toJSON(jsonTxt);
        DAM_MESSAGE_TYPE msgType = DAM_MESSAGE_TYPE.valueOf(json.getString(JsonFieldNameConstants.MESSAGE_TYPE));
        int protocolVersion = json.getInt(JsonFieldNameConstants.PROTOCOL_VERSION);
        switch (msgType) {
        case DATA:
            returnValue = parseData(protocolVersion, json);
            break;
        // case ASK: returnValue =; break;
        // case REGISTER: returnValue =; break;
        // case CONFIG: returnValue =; break;
        default:
        }
        return returnValue;
    }

    private static IncomingData parseData(int protocolVersion, JSONObject json) {
        IncomingData data = new IncomingData();
        data.setDeviceChannelId(json.getInt(JsonFieldNameConstants.DEVICE_CHANNEL_ID));
        data.setSamplingRate(json.getInt(JsonFieldNameConstants.SAMPLING_RATE));
        data.setRpm(json.getInt(JsonFieldNameConstants.RPM));
        data.setSamplingSize(json.getInt(JsonFieldNameConstants.SAMPLE_SIZE));
        JSONArray dataArray = json.getJSONArray(JsonFieldNameConstants.DATA);
        // of 2 byte numbers for version 2 array of doubles for version 3
        switch (protocolVersion) {
        case 2:
            byte byteData[] = new byte[dataArray.size()];
            for (int i = 0; i < dataArray.size(); i++) {
                byteData[i] = dataArray.getString(i).getBytes()[0];
            }
            data.setByteData(byteData);
            break;
        case 3:
            double doubleData[] = new double[dataArray.size()];
            for (int i = 0; i < dataArray.size(); i++) {
                doubleData[i] = dataArray.getDouble(i);
            }
            data.setDoubleData(doubleData);
            break;
        }
        data.setUnit(json.getString(JsonFieldNameConstants.UNIT));
        return data;
    }
    
    public static String toJson(List<TreeNode> roots) {
        JSONArray treeArray = new JSONArray();
        for (TreeNode node : roots) {
            treeArray.add(toJson(node));
        }
        return (new JSONObject()).element(JsonFieldNameConstants.ITEMS, treeArray).toString();
    }

    public static JSONObject toJson(TreeNode node){
        JSONObject json = (new JSONObject()).element(JsonFieldNameConstants.NAME,node.getName());
        if (node.getChildren() != null) {
            JSONArray array = new JSONArray();
            for (TreeNode child : node.getChildren()) {
                array.add(toJson(child));
            }
            json.element(JsonFieldNameConstants.ITEMS, array);
        } else {
            json.element(JsonFieldNameConstants.LEAF, true);
            JSONArray array = new JSONArray();
            // now is just one element
            /*
             * Seichas u nas struktura takaya: facility>>machine>>sensor. Seichas sensor est' "leaf". A nuzna takaya:
             * facility>>machine>>point>>sensor. Togda point budet "leaf". A sensors budut ego deti. No etogo poka net.
             */
            JSONObject leaf = (new JSONObject()).element(JsonFieldNameConstants.SENSOR_ID,node.getName()).element(JsonFieldNameConstants.CHANNEL_ID,node.getChannelId());
            array.add(leaf);
            json.element(JsonFieldNameConstants.CONTENT, array);
        }
        return json;
    }
}
