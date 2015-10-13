package cn.com.ethank.yunge.pad.bean;

import java.io.Serializable;

/**
 * Created by dddd on 2015/4/28.
 */
public class SinglerBean implements Serializable{
    private String SinglerName;
    private String SinglerId;
    private String headUrl;

    public String getSinglerName() {
        return SinglerName;
    }

    public void setSinglerName(String singlerName) {
        SinglerName = singlerName;
    }

    public String getSinglerId() {
        return SinglerId;
    }

    public void setSinglerId(String singlerId) {
        SinglerId = singlerId;
    }

    public String getHeadUrl() {
        return headUrl;
    }

    public void setHeadUrl(String headUrl) {
        this.headUrl = headUrl;
    }
}
