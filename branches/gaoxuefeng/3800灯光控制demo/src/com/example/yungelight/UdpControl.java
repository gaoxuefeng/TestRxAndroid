package com.example.yungelight;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;

/**
 * Created by lvhonghe on 15/7/22.
 */
public class UdpControl {


    private static UdpControl INST = new UdpControl();

    public static UdpControl getInst() {
        return INST;
    }

    /**
     *
     * UDP客户端程序，用于对服务端发送数据，并接收服务端的回应信息
     */
    private byte[] buffer = new byte[1024];

    private DatagramSocket ds = null;
//
//    /**
//     * 测试客户端发包和接收回应信息的方法
//     */
//    public static void main(String[] args) throws Exception {
//        UdpControl client = new UdpControl();
//        String serverHost = "127.0.0.1";
//        int serverPort = 3344;
//        client.send(serverHost, serverPort, ("你好，亲爱的!").getBytes());
//        byte[] bt = client.receive();
//        System.out.println("服务端回应数据：" + new String(bt));
//        // 关闭连接
//        try {
//            ds.close();
//        } catch (Exception ex) {
//            ex.printStackTrace();
//        }
//    }

    /**
     * 构造函数，创建UDP客户端
     */
    private UdpControl() {
        init();
    }

    private void init() {
        if(ds != null) {
            return;
        }
        try {
            ds = new DatagramSocket(8090); // 邦定本地端口作为客户端
        } catch (SocketException e) {
            e.printStackTrace();
        }
    }

    /**
     * 向指定的服务端发送数据信息
     */
    public final void send(final String host, final int port,
                           final byte[] bytes) throws IOException {
        DatagramPacket dp = new DatagramPacket(bytes, bytes.length, InetAddress.getByName(host), port);
        ds.send(dp);
    }



    private static final String HOST = "192.168.1.197";
    private static final int PORT = 8089;

    public static final byte[] AIR_OPEN = new byte[] {
            (byte)0xCF,
            (byte)0x01,
            (byte)0x9A,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0xB0
    };

    public static final byte[] AIR_CLOSE = new byte[] {
            (byte)0xCF,
            (byte)0x01,
            (byte)0x9B,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0xB0
    };

    public static final byte[] AIR_STAGE1 = new byte[] {
            (byte)0xCF,
            (byte)0x01,
            (byte)0x9A,
            (byte)0x00,
            (byte)0x8A,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0xB0
    };

    public static final byte[] AIR_STAGE2 = new byte[] {
            (byte)0xCF,
            (byte)0x01,
            (byte)0x9A,
            (byte)0x00,
            (byte)0x8A,
            (byte)0xB0,
            (byte)0x00,
            (byte)0x00,
            (byte)0xB0
    };

    public static final byte[] AIR_STAGE3 = new byte[] {
            (byte)0xCF,
            (byte)0x01,
            (byte)0x9A,
            (byte)0x00,
            (byte)0x8C,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0xB0
    };

    public static final byte[] AIR_AUTO = new byte[] {
            (byte)0xCF,
            (byte)0x01,
            (byte)0x9A,
            (byte)0x00,
            (byte)0x8D,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0xB0
    };

    public static final byte[] AIR_INCREMENT = new byte[] {
            (byte)0xCF,
            (byte)0x01,
            (byte)0x9A,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0x9E,
            (byte)0x00,
            (byte)0xB0
    };

    public static final byte[] AIR_DEGREE = new byte[] {
            (byte)0xCF,
            (byte)0x01,
            (byte)0x9A,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0x9F,
            (byte)0x00,
            (byte)0xB0
    };

    public static final byte[] AIR_COOL = new byte[] {
            (byte)0xCF,
            (byte)0x01,
            (byte)0x9A,
            (byte)0x6A,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0xB0
    };

    public static final byte[] AIR_HOT = new byte[] {
            (byte)0xCF,
            (byte)0x01,
            (byte)0x9A,
            (byte)0x6B,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0xB0
    };

    public static final byte[] AIR_WIND = new byte[] {
            (byte)0xCF,
            (byte)0x01,
            (byte)0x9A,
            (byte)0x6C,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0xB0
    };

    public static final byte[] AIR_EXHAUST_OPEN = new byte[] {
            (byte)0xCF,
            (byte)0x01,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0x50,
            (byte)0xB0
    };

    public static final byte[] AIR_EXHAUST_CLOSE = new byte[] {
            (byte)0xCF,
            (byte)0x01,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0x00,
            (byte)0x51,
            (byte)0xB0
    };

    public static final byte[] LIGHT_LANGMAN = new byte[] {
            (byte)0xFB,
            (byte)0x0A,
            (byte)0xC0,

    };

    public final void send(final byte[] data) throws IOException {
      
        init();
        DatagramPacket dp = new DatagramPacket(data, data.length, InetAddress.getByName(HOST), PORT);
        ds.send(dp);
    }

    /**
     * 接收从指定的服务端发回的数据
     */
    public final byte[] receive()
            throws Exception {
        DatagramPacket dp = new DatagramPacket(buffer, buffer.length);
        ds.receive(dp);
        byte[] data = new byte[dp.getLength()];
        System.arraycopy(dp.getData(), 0, data, 0, dp.getLength());
        return data;
    }

}
