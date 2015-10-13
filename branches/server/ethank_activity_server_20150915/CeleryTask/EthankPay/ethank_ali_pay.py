# -*- coding: utf-8 -*-
'''
Created on 2015年9月14日

@author: li.zheshen
'''
import hashlib


class EthankAliPay(object):
    def __init__(self, pid="2088711341640795", key="4qm6l11jhfm5297urhnyyfmebsezzbxg"):
        self.pid = pid
        self.key = key
        self.base_url = "https://mapi.alipay.com/gateway.do"
        self.input_charset = "utf-8"
        self.it_b_pay = "10m"
        self.notify_url = ""
        self.out_trade_no = "88888888"
        self.partner = pid
        self.payment_type = "1"
        self.return_url = ""
        self.seller_id = pid
        self.service = "alipay.wap.create.direct.pay.by.user"
        self.sign = ""
        self.sign_type = "MD5"
        self.subject = "ticket"
        self.total_fee = "1"

    def set_order_id(self, order_id):
        self.out_trade_no = order_id

    def set_total_pay(self, pay):
        self.total_fee = pay

    def set_return_url(self, return_url):
        self.return_url = return_url

    def set_notify_url(self, notify_url):
        self.notify_url = notify_url

    def _make_sign(self):
        body = ""
        if self.input_charset:
            body += "_input_charset=" + self.input_charset
        if self.it_b_pay:
            body += "&it_b_pay=" + self.it_b_pay
        if self.notify_url:
            body += "&notify_url=" + self.notify_url
        if self.out_trade_no:
            body += "&out_trade_no=" + self.out_trade_no
        if self.partner:
            body += "&partner=" + self.partner
        if self.payment_type:
            body += "&payment_type=" + self.payment_type
        if self.return_url:
            body += "&return_url="+self.return_url
        if self.seller_id:
            body += "&seller_id=" + self.seller_id
        if self.service:
            body += "&service=" + self.service
        if self.subject:
            body += "&subject=" + self.subject
        if self.total_fee:
            body += "&total_fee=" + self.total_fee
        body += self.key
        print body
        sign = hashlib.md5(body).hexdigest()
        self.sign = sign

    def build_link(self):
        self._make_sign()
        body = self.base_url+"?"
        if self.input_charset:
            body += "_input_charset=" + self.input_charset
        if self.it_b_pay:
            body += "&it_b_pay=" + self.it_b_pay
        if self.notify_url:
            body += "&notify_url=" + self.notify_url
        if self.out_trade_no:
            body += "&out_trade_no=" + self.out_trade_no
        if self.partner:
            body += "&partner=" + self.partner
        if self.payment_type:
            body += "&payment_type=" + self.payment_type
        if self.return_url:
            body += "&return_url="+self.return_url
        if self.seller_id:
            body += "&seller_id=" + self.seller_id
        if self.service:
            body += "&service=" + self.service
        if self.subject:
            body += "&subject=" + self.subject
        if self.sign_type:
            body += "&sign_type=" + self.sign_type
        if self.sign:
            body += "&sign=" + self.sign
        if self.total_fee:
            body += "&total_fee=" + self.total_fee
        print body
        return body

    def check_link(self):
        pass
# ali_pay = EthankAliPay()
# ali_pay.set_order_id("123457")
# ali_pay.set_total_pay("0.01")
# ali_pay.set_return_url("http://www.baidu.com")
# ali_pay.build_link()
