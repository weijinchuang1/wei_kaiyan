import { getHomeListAxios } from '../http/apiServers';
import axiosClient from '../http/AxiosRequest';
import { HomeModelIssueListItemList } from '../model/HomeModel';
import { BaseViewModel, ResultCallback } from './BaseViewModel';
export class HomeViewModel extends BaseViewModel {

  /**
   * 获取首页列表数据-axios客户端请求
   * @param stateCallback  状态返回
   * @param resultCallback  结果返回
   */
  async getHomeList(resultCallback?: ResultCallback<HomeModelIssueListItemList[]>) {
    await this.httpRequest(getHomeListAxios()).then(result => {
        let items = result.issueList[0].itemList
        let list = items.filter((item) => item.type == "video")
        let bannerList: HomeModelIssueListItemList[]
        let bannerBean: HomeModelIssueListItemList = {}
        bannerList = items.filter((item) => item.type == "banner2")
        if (bannerList.length > 0) {
          bannerBean = { bannerList: bannerList, type: "banner" }
          list.unshift(bannerBean)
        }
        resultCallback?.(list)
        this.spliteDate(result.nextPageUrl)
      })
  }
  private spliteDate(nextUrl: string) {
    let split = nextUrl.split("?");
    let split2 = split[1];
    let split3 = split2.split("&");
    let split4 = split3[0].split("=");

  }
}
let homeViewModel = new HomeViewModel()
export default homeViewModel as HomeViewModel