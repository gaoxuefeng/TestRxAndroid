package rxdemo.ethank.com.cn.testrxandroid;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;
import android.widget.Toast;

import butterknife.Bind;
import butterknife.ButterKnife;
import rx.Observable;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;

public class MainActivity extends Activity {
    @Bind(R.id.tv_hello)
    TextView tv_hello;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ButterKnife.bind(this);
        //创建观察者
        Observable observable = Observable.create(mObservableAction);
        //指定在主线程中
        observable.observeOn(AndroidSchedulers.mainThread());
        //=分发订阅信息
        observable.subscribe(mTextSubscriber);
        observable.subscribe(mToastSubscriber);
        Observable observable1 = Observable.create(mObservableAction);

    }

    // 创建字符串
    private String sayMyName() {
        return "Hello, I am your friend, Spike!";
    }

    Observable.OnSubscribe mObservableAction = new Observable.OnSubscribe() {
        @Override
        public void call(Object o) {
            if (o instanceof Subscriber) {

                Subscriber subscriber = (Subscriber) o;
                subscriber.onNext(sayMyName()); // 发送事件
                subscriber.onCompleted(); // 完成事件
            }
        }

    };
    // 订阅者, 接收字符串, 修改控件
    Subscriber mTextSubscriber = new Subscriber() {
        @Override
        public void onCompleted() {

        }

        @Override
        public void onError(Throwable e) {
        }

        @Override
        public void onNext(Object o) {
            tv_hello.setText((CharSequence) o);
        }
    };
    // 订阅者, 接收字符串, 提示信息
    Subscriber mToastSubscriber = new Subscriber() {
        @Override
        public void onCompleted() {

        }

        @Override
        public void onError(Throwable e) {

        }

        @Override
        public void onNext(Object o) {
            Toast.makeText(MainActivity.this, (CharSequence) o, Toast.LENGTH_SHORT).show();
        }


    };
}
