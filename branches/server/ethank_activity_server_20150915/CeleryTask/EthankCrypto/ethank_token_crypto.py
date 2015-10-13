# -*- coding: utf-8 -*-
'''
Created on 2015年8月20日

@author: li.zheshen
'''
from Crypto.Cipher import DES


class ethank_token_crypto(object):

    def __init__(self, des_key="national"):
        '''
        Constructor
        '''
        self.des_key = des_key
        self.hex_list = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                         'a', 'b', 'c', 'd', 'e', 'f')

        self.hex_dict = {'0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5,
                         '6': 6, '7': 7, '8': 8, '9': 9, 'a': 10, 'b': 11,
                         'c': 12, 'd': 13, 'e': 14, 'f': 15}

        key = self._get_key(self.des_key)

        self.des_obj = DES.new(key, DES.MODE_ECB)

    def encrypt(self, plain_text):
        ret = ""
        try:
            crypt_text = self.des_obj.encrypt(self._pad(plain_text))
            ret = self._byteArr2HexStr(crypt_text)
        except Exception, e:
            print e
        finally:
            return ret

    def decrypt(self, crypt_text):
        ret = ""
        try:
            byte_str = self._hexStr2byteArr(crypt_text)
            plain_text = self.des_obj.decrypt(byte_str)
            ret = self._del_pad(plain_text)
        except Exception, e:
            print e
        finally:
            return ret

    def _byteArr2HexStr(self, byte_arr):
        hex_list = list()
        for ch in byte_arr:
            tmp = ord(ch)
            if tmp < 16:
                hex_list.append("0")
                hex_list.append(self.hex_list[tmp % 16])
            else:
                hex_list.append(self.hex_list[(tmp / 16) % 16])
                hex_list.append(self.hex_list[tmp % 16])

        hex_str = ''.join(hex_list)
        return hex_str

    def _hexStr2byteArr(self, hex_str):
        byte_list = list()
        flg = 0
        for ch in hex_str:
            if flg == 0:
                flg = 1
                h_str = ch
            else:
                l_str = ch
                byte_list.append(
                                 chr(self.hex_dict[h_str] * 16 +
                                     self.hex_dict[l_str]))
                flg = 0
        byte_str = ''.join(byte_list)
        return byte_str

    def _pad(self, s):
        return s + chr(4) * (DES.block_size - len(s) % DES.block_size)

    def _del_pad(self, s):
        for idx, ch in enumerate(reversed(s)):
            if ord(ch) > 31:  # 去掉非可见字符
                return s[:-idx]

    def _get_key(self, key_str):
        key_list = ['\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0']
        for idx, ch in enumerate(key_str):
            if idx >= 8:
                break
            key_list[idx] = ch
        key = ''.join(key_list)
        return key
# if __name__ == "__main__":
#     token = ethank_token_crypto()
#     print token.decrypt("5cd777a6ac8b43786e8662b6d7f37c27")