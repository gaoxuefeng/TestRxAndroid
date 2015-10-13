-- ============================================================
--   Auther: 李哲申        
-- ============================================================

-- ----------------------------
-- *活动物品表
-- ----------------------------
DROP TABLE IF EXISTS `t_activity_goods`;
CREATE TABLE `t_activity_goods` (
  `goods_id` int(11) NOT NULL AUTO_INCREMENT,        -- * 活动物品id
  `goods_group` int(11) NOT NULL,                    -- * 活动类型分组
  `goods_name` varchar(255) DEFAULT NULL,            -- * 活动物品名字
  `goods_status` tinyint(4) DEFAULT NULL,            -- * 活动物品状态
  `goods_prize_pool` int(11) NOT NULL,               -- * 活动物品表
  `goods_order_id` varchar(255) DEFAULT NULL,          -- * 活动物品订单号
  `goods_verify_code` varchar(255) DEFAULT NULL,       -- * 活动物品验证码
  `goods_activity_date` date NULL DEFAULT NULL,      -- * 活动物品使用时间 
  PRIMARY KEY (`goods_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `t_activity_goods` VALUES (1, 1, 'ticket', 1, 0, '201509158881', 'mRFMbe', '2015-9-16');
INSERT INTO `t_activity_goods` VALUES (2, 1, 'ticket', 1, 0, '201509158882', 'nRFMbe', '2015-9-16');
INSERT INTO `t_activity_goods` VALUES (3, 1, 'ticket', 1, 0, '201509158883', 'oRFMbe', '2015-9-16');
INSERT INTO `t_activity_goods` VALUES (4, 1, 'ticket', 1, 0, '201509158884', 'pRFMbe', '2015-9-16');
INSERT INTO `t_activity_goods` VALUES (5, 1, 'ticket', 1, 0, '201509158885', 'qRFMbe', '2015-9-16');
INSERT INTO `t_activity_goods` VALUES (6, 1, 'ticket', 1, 0, '201509158886', 'rRFMbe', '2015-9-17');
INSERT INTO `t_activity_goods` VALUES (7, 1, 'ticket', 1, 0, '201509158887', 'sRFMbe', '2015-9-17');
INSERT INTO `t_activity_goods` VALUES (8, 1, 'ticket', 1, 0, '201509158888', 'tRFMbe', '2015-9-17');
INSERT INTO `t_activity_goods` VALUES (9, 1, 'ticket', 1, 0, '201509158889', 'uRFMbe', '2015-9-17');
INSERT INTO `t_activity_goods` VALUES (10, 1, 'ticket', 1, 0, '201509158890', 'vRFMbe', '2015-9-17');
INSERT INTO `t_activity_goods` VALUES (11, 1, 'ticket', 1, 0, '201509158891', 'wRFMbe', '2015-9-18');
INSERT INTO `t_activity_goods` VALUES (12, 1, 'ticket', 1, 0, '201509158892', 'xRFMbe', '2015-9-18');
INSERT INTO `t_activity_goods` VALUES (13, 1, 'ticket', 1, 0, '201509158893', 'yRFMbe', '2015-9-18');
INSERT INTO `t_activity_goods` VALUES (14, 1, 'ticket', 1, 0, '201509158894', 'zRFMbe', '2015-9-18');
INSERT INTO `t_activity_goods` VALUES (15, 1, 'ticket', 1, 0, '201509158895', 'ARFMbe', '2015-9-18');


-- ----------------------------
-- *中奖记录表
-- ----------------------------
DROP TABLE IF EXISTS `t_activity_win_record`;
CREATE TABLE `t_activity_win_record` (
  `win_record_id` int(11) NOT NULL AUTO_INCREMENT,   -- * 中奖纪录id
  `win_record_activity_id` int(11) NOT NULL,         -- * 中间活动id 
  `win_record_user_id` int(11) NOT NULL,             -- * 中奖用户id
  `win_record_order_id` varchar(255) DEFAULT NULL,   -- * 中奖订单id
  `win_record_out_order_id` varchar(255) DEFAULT NULL, -- * 外部订单id
  `win_record_nick_name` varchar(255) DEFAULT NULL,  -- * 中奖用户昵称
  `win_record_time` varchar(255) DEFAULT NULL,       -- * 中奖时间
  `win_record_sequence`  int(11) DEFAULT NULL,     -- * 中奖序号  
  `win_record_note` varchar(255) DEFAULT NULL,         -- * 中奖备注
  `win_record_phone` varchar(255) DEFAULT NULL,      -- * 中奖手机号
  `win_record_address` varchar(255) DEFAULT NULL,    -- * 中奖地址  
  `win_record_pay_url` varchar(1024) DEFAULT NULL,    -- * 中奖支付链接  
  `win_record_pay_status` int(11) NOT NULL,          -- * 支付状态id
  `win_record_verify_code` varchar(255) DEFAULT NULL,-- * 中奖验证码  
  PRIMARY KEY (`win_record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- ----------------------------
-- *vip表
-- ----------------------------
DROP TABLE IF EXISTS `t_activity_seckill_vip`;
CREATE TABLE `t_activity_seckill_vip` (
  `seckill_vip_id` int(11) NOT NULL AUTO_INCREMENT,   -- * vip id
  `seckill_vip_user_id` int(11) NOT NULL,             -- * vip 用户id
  `seckill_vip_date` varchar(255) DEFAULT NULL,       -- * vip时间
  PRIMARY KEY (`seckill_vip_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;