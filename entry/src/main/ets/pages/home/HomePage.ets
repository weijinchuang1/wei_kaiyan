/**
 * 首页
 */
import { ViewStateConstant } from '../../constants/ViewStateConstant';
import { HomeModel, HomeModelIssueListItemList } from '../../model/HomeModel';
import { CommonTopBar } from '../../views/CommonTopBar';

import { HomeListItemComponent } from './component/HomeListItemComponent';
import { Router } from '../../route/Router'
import { RoutePath } from '../../route/RoutePath';
import { CategoryRouteParams } from '../../route/RouteParams';

import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

import axios, {
    AxiosHeaders,
   AxiosInstance,
  AxiosRequestConfig,
    AxiosRequestHeaders,
   AxiosResponse,
   InternalAxiosRequestConfig
  } from "@ohos/axios";
import axiosClient from '../../http/AxiosRequest';
import HomeViewModel from '../../viewmodel/HomeViewModel';
import { window } from '@kit.ArkUI';

// let baseUrl = "http://10.161.9.80:7012/"
let baseUrl = "https://baobab.kaiyanapp.com/"
const commonHeader: AxiosHeaders = new AxiosHeaders()

@Entry
@Component
export  default struct HomePage {

  windowStage: window.WindowStage = AppStorage.get("windowStage") as window.WindowStage;
  mainWin: window.Window = this.windowStage.getMainWindowSync();
  @State isRefreshing:boolean=false
  @State showState:boolean=false
  @State dataList:HomeModelIssueListItemList[]=[]

  isSubscribe:boolean=true

  aboutToAppear(): void {
    HomeViewModel.getHomeList((result) => {
      this.dataList = result
    })
  }

  getHomeListAxios(page: number = 1) {
    let instance = axios.create({
      baseURL: "http://10.161.9.80:7012/", //基路径，要看API帮助文档的特征来确定基路径
      timeout: 5000, //请求超时的时间
      headers: {
               "Content-Type": "application/json"

      }

    })
  }
  axiosDemo(){
        //创建axios的实例
        let instance  = axios.create({
            baseURL: "http://10.161.9.80:7012", //基路径，要看API帮助文档的特征来确定基路径
            timeout: 5000, //请求超时的时间
            headers: {
                "Content-Type": "application/json"
              }
         })

        instance.get("/api/v2/feed?page=3").then((res: AxiosResponse) => {
            if (res.status == 200) { // 状态码
                // 返回数据
                console.info('Result:' + JSON.stringify(res.data));
              }}).catch((err: BusinessError) => {

            }).finally(() => {

          })

      }

  httpDemo(){
        let httpRequest = http.createHttp();
        httpRequest.request(
            // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
            "http://10.161.9.80:7012/api/v2/feed?page=1",
            {
                method: http.RequestMethod.GET, // 可选，默认为http.RequestMethod.GET
                connectTimeout: 60000, // 可选，默认为60000ms
                readTimeout: 60000, // 可选，默认为60000ms
              }, (err: BusinessError, data: http.HttpResponse) => {
            if (!err) {
                // data.result为HTTP响应内容，可根据业务需要进行解析
                console.info('Result:' + JSON.stringify(data.result));
                console.info('code:' + JSON.stringify(data.responseCode));
                // data.header为HTTP响应头，可根据业务需要进行解析
                console.info('header:' + JSON.stringify(data.header));
                console.info('cookies:' + JSON.stringify(data.cookies)); // 8+
                // 当该请求使用完毕时，调用destroy方法主动销毁
                httpRequest.destroy();
              } else {
                console.error('error:' + JSON.stringify(err));
                httpRequest.destroy();
              }
          })
      }


  build() {
    Column(){
      CommonTopBar({ title: "首页", backButton: false, alpha: 1 }).align(Alignment.TopStart)
      Stack(){
          Refresh({ refreshing: $$this.isRefreshing, offset: 100, friction: 100 }) {
            List({ space: 10, initialIndex: 0 }) {
              ForEach(this.dataList, (item: HomeModelIssueListItemList, index: number) => {
                                ListItem() {
                                    HomeListItemComponent({ item: item }).onClick(() => {
                                        Router.push(RoutePath.DetailPage, {
                                            "id": item?.data?.id,
                                            "playUrl": item?.data?.playUrl
                                          } as CategoryRouteParams)
                  })
                }
              })
            }

        }
      }.layoutWeight(1)
         }
      }
  }

function getDemo() {
  return axiosClient.get<HomeModel>({
    url: baseUrl + "api/v2/feed",
    params: { "page": 1 },
    showLoading: true,
    headers: commonHeader
  })
}
