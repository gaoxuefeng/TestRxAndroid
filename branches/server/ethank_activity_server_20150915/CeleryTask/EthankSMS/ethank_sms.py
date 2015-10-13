# -*- coding: utf-8 -*-
'''
Created on 2015年9月12日

@author: li.zheshen
'''
import requests
import hashlib
import re
import urllib


class ethank_sms(object):
    def __init__(self,
                 sn="SDK-YOU-010-00031",
                 passwd="b-162a-[",
                 sign="【潮趴汇】"):
        self.sn = sn
        self.password = passwd
        self.sign = sign
        self.pwd = hashlib.md5(self.sn + self.password).hexdigest().upper()

    def send_sms(self, tel, content):
        url = "http://sdk2.entinfo.cn:8061/webservice.asmx"
        is_ok = False
        try:
            xml = self._build_xml(tel, content)
            data = xml.decode("utf-8").encode("gb18030")
            header = {"Content-Type": "text/xml; charset=gb2312",
                      "SOAPAction": "http://entinfo.cn/mdgxsend"}
            r = requests.post(url, headers=header, data=data)
            print r.text
            lst = re.findall("mdgxsendResult\>[0-9]+\<\/mdgxsendResult",
                             r.text,
                             re.MULTILINE)
            if lst:
                print lst
                is_ok = True
        except Exception,e:
            print e
            is_ok = False
        return is_ok

    def _build_xml(self, tel, content):
        xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
        xml = xml + ("<soap:Envelope "
                     "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
                     "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                     "xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">")
        xml = xml + "<soap:Body>"
        xml = xml + "<mdgxsend  xmlns=\"http://entinfo.cn/\">"
        xml = xml + "<sn>" + self.sn + "</sn>"
        xml = xml + "<pwd>" + self.pwd + "</pwd>"
        xml = xml + "<mobile>" + tel + "</mobile>"
        xml = xml + "<content>" + urllib.quote(self.sign + content +self.sign) +"</content>"
        xml = xml + "<ext>" + "" + "</ext>"
        xml = xml + "<stime>" + "" + "</stime>"
        xml = xml + "<rrid>" + "" + "</rrid>"
        xml = xml + "<msgfmt>" + "" + "</msgfmt>"
        xml = xml + "</mdgxsend>"
        xml = xml + "</soap:Body>"
        xml = xml + "</soap:Envelope>"
        print urllib.quote(self.sign + content)
        return xml

if __name__== "__main__":
    verify_code = "123456"
    tel = "13488692468"
    sms = ethank_sms()
    content = "潮趴汇喜您成功秒杀“真●我巅峰”演唱会门票2张。您的抢票验证码为"+\
                verify_code.encode("UTF-8")+\
                "，演唱会时间：2015年9月22日19：20。"+\
                "请在演唱会开始前80分钟到北京国家体育馆鸟巢“潮趴汇领票处”凭验证码领取门票，"+\
                "找不到人请拨：18561601603"

    print sms.send_sms(tel.encode("utf-8"), content)

