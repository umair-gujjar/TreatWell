/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.alberta.sms;

import com.alberta.dao.DAO;
import java.util.ArrayList;
import java.util.List;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;

/**
 *
 * @author farazahmad
 */
public class SmsServiceImpl implements SmsService {

    private DAO dao;

    /**
     * @return the dao
     */
    @Override
    public DAO getDao() {
        return dao;
    }

    /**
     * @param dao the dao to set
     */
    @Override
    public void setDao(DAO dao) {
        this.dao = dao;
    }

    public boolean sendSignUpMessage(String mobileNo, String userName, String password) {
        boolean flag = false;
        try {
            CloseableHttpClient httpclient = HttpClients.createDefault();
            String message = "Your login details are: UserName: " + userName + " Password: " + password + " Please login to www.treatwellservices.com";
            String url = "http://pk.eocean.us/APIManagement/API/RequestAPI?user=TWS&pwd=ANreowHdVt%2fbvT6ubUCK01SuOXWcxjM5H2QOUH1MUdnBh1fhqiq4kWFJjPctIAFSlA%3d%3d";
            HttpPost httpPost = new HttpPost(url);
            List<NameValuePair> nvps = new ArrayList<NameValuePair>();
            nvps.add(new BasicNameValuePair("sender", "TWS"));
            nvps.add(new BasicNameValuePair("reciever", mobileNo));
            nvps.add(new BasicNameValuePair("msg-data", message));
            nvps.add(new BasicNameValuePair("response", "string"));
            httpPost.setEntity(new UrlEncodedFormEntity(nvps));
            CloseableHttpResponse response2 = httpclient.execute(httpPost);
            System.out.println(response2.getStatusLine());
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return flag;
    }
}