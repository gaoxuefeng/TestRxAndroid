package rxdemo.ethank.com.cn.testrxandroid;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;
import android.widget.Toast;

import java.util.Arrays;
import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;
import rx.Observable;
import rx.android.schedulers.AndroidSchedulers;
import rx.functions.Action1;
import rx.functions.Func1;
import rx.functions.Func2;
//        just: 获取输入数据, 直接分发, 更加简洁, 省略其他回调.
//        from: 获取输入数组, 转变单个元素分发.
//        map: 映射, 对输入数据进行转换, 如大写.
//        flatMap: 增大, 本意就是增肥, 把输入数组映射多个值, 依次分发.
//        reduce: 简化, 正好相反, 把多个数组的值, 组合成一个数据.

/**
 * 更多的RxAndroid的使用方法.
 * <p/>
 */
public class MoreActivity extends Activity {
    @Bind(R.id.tv_hello)
    TextView mTvText;
    final String[] mManyWords = {"Hello", "I", "am", "your", "friend", "Spike"};
    final List mManyWordList = Arrays.asList(mManyWords);
    // Action类似订阅者, 设置TextView private
    Action1 mTextViewAction = new Action1() {
        @Override
        public void call(Object o) {
            mTvText.setText((CharSequence) o);
        }


    }; // Action设置Toast
    private Action1 mToastAction = new Action1() {
        @Override
        public void call(Object o) {
            Toast.makeText(MoreActivity.this, (String) o, Toast.LENGTH_SHORT).show();
        }


    }; // 设置映射函数


    Func1<List, Observable<?>> mOneLetterFunc = new Func1<List, Observable<?>>() {

        @Override
        public Observable call(List list) {
            return Observable.from(list); // 映射字符串
        }
    }; // 设置大写字母
    private Func1 mUpperLetterFunc = new Func1() {


        @Override
        public String call(Object s) {
            return ((String) s).toUpperCase(); // 大小字母
        }
    };
    // 连接字符串
    private Func2 mMergeStringFunc = new Func2() {
        @Override
        public String call(Object s, Object s2) {
            return String.format("%s %s", s, s2);
            // 空格连接字符串
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ButterKnife.bind(this);
        // 添加字符串, 省略Action的其他方法, 只使用一个onNext.
        Observable obShow = Observable.just(sayMyName());
        // 先映射, 再设置TextView
        obShow.observeOn(AndroidSchedulers.mainThread()).map(mUpperLetterFunc).subscribe(mTextViewAction);
        // 单独显示数组中的每个元素
        Observable obMap = Observable.from(mManyWords);
        // 映射之后分发
        obMap.observeOn(AndroidSchedulers.mainThread()).map(mUpperLetterFunc).subscribe(mToastAction);
        // 优化过的代码, 直接获取数组, 再分发, 再合并, 再显示toast, Toast顺次执行.
        Observable.just(mManyWordList).observeOn(AndroidSchedulers.mainThread()).flatMap(mOneLetterFunc).reduce(mMergeStringFunc).subscribe(mToastAction);
    }
    //                  创建字符串

    private String sayMyName() {
        return "Hello, I am your friend, Spike!";
    }
};

