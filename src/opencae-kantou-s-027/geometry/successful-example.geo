//
// オープンCAE勉強会＠関西　での報告用の形状
//
//     報告者： ichmy55
//     報告日： 2024年4月22日
//     報告　： 第99回オープンCAE勉強会＠関西
//
//     形状名： failure-example.geo
//     概要　： ６面体では切れる形状の例
//　
SetFactory("OpenCASCADE");    //CADカーネルをOpenCASCADEに指定
//
// 形状の基本寸法を定める変数定義
//
lr  = 100. ; // 球殻及び円筒の内面半径
ld  =  20. ; // 球殻及び円筒の肉厚
ll  = 100. ; // 円筒部長さ／２（1/8モデルで作成するため円筒部長さを1/2とする）
ll2 =  20. ; // 円筒下部に作るメッシュをより細かくする範囲の高さ
lc =    1.0; // メッシュサイズ（仮値）
//
// 球殻、円筒の左側面を形成する各点の作成
//
p1 = newp; Point(p1)  = {  0. ,   0. , 0., lc}; // 円の中心
p2 = newp; Point(p2)  = { lr  ,   0. , 0., lc}; // 内側円弧の始点
p3 = newp; Point(p3)  = {  0. ,  lr  , 0., lc}; // 内側円弧の終点
p4 = newp; Point(p4)  = {lr+ld,   0. , 0., lc}; // 外側円弧の始点
p5 = newp; Point(p5)  = {  0. , lr+ld, 0., lc}; // 外側円弧の終点
p6 = newp; Point(p6)  = { lr  , -ll  , 0., lc}; // 内側円筒面の終点
p7 = newp; Point(p7)  = {lr+ld, -ll  , 0., lc}; // 外側円筒面の終点
//
// 球殻、円筒の左側面を形成する各線の作成
//
c1 = newc; Circle(c1) = { p2, p1, p3}; // 内側円弧
c2 = newc; Circle(c2) = { p4, p1, p5}; // 外側円弧
c3 = newc; Line(c3)   = { p3, p5 };    // 球殻左側面の端部
c4 = newc; Line(c4)   = { p2, p6 };    // 円筒部内側線
c5 = newc; Line(c5)   = { p4, p7 };    // 円筒部外側線
c6 = newc; Line(c6)   = { p6, p7 };    // 円筒部下側線
//
// 球殻＋円筒の左側面の作成
//
cl1 = newcl; Curve Loop(cl1) = {c3, -c2, c5, -c6, -c4, -c1};
s1  = news;  Plane Surface(s1) = {cl1};      // 球殻、円筒の左側面
//
// 上記側面をｙ軸回り90度(π/2)回転させて球殻、円筒を作成
//
out[] = Extrude{{0,1,0},{0,0,0},Pi/2}{Surface{s1}; }; //回転押し出し
v1    = out[1];  //作成された球殻のiD
//
// 切断する工具（直方体)を作成する
// 工具その１＝円筒を上下に切断する
//
v2 = newv;  Box(v2) = {-lr, ll+2*lr, lr, 3*lr, -2*ll-2*lr+ll2, -3*lr};
//
// 円筒下部を切り出す
//
v3 = newv; BooleanDifference(v3) = {Volume{v1};}{Volume{v2};};
//
// 円筒上部＋球殻を切り出す
//
v4 = newv; BooleanIntersection(v4) = {Volume{v1}; Delete;}{Volume{v2};};
//
// 工具その1を上方に移動する（球殻と円筒の切り分け用）
//
Translate {0, ll-ll2, 0} { Volume{v2}; }
//
// 円筒上部を切り出す
//
v5 = newv; BooleanDifference(v5) = {Volume{v4};}{Volume{v2};};
//
// 球殻を切り出す
//
v6 = newv; BooleanIntersection(v6) = {Volume{v4}; Delete;}{Volume{v2};};
//
// 工具その２＝物体を左右に切り分ける
// 工具その１を下方に移動し、ｙ軸回り４５度(π/4)回転
//
Translate {0, -ll-3*ll2, 0} { Volume{v2}; }
Rotate {{0, 1, 0}, {-lr, 0, lr}, Pi/4} { Volume{v2}; }
//
// 円筒下部右側を切り出す
//
v7 = newv; BooleanDifference(v7) = {Volume{v3};}{Volume{v2};};
//
// 円筒下部左側を切り出す（元の円筒下部はもう使わないので削除）
//
v8 = newv; BooleanIntersection(v8) = {Volume{v3}; Delete;}{Volume{v2};};
//
// 円筒上部右側を切り出す
//
v9 = newv; BooleanDifference(v9) = {Volume{v5};}{Volume{v2};};
//
// 円筒上部左側を切り出す（元の円筒上部はもう使わないので削除）
//
v10 = newv; BooleanIntersection(v10) = {Volume{v5}; Delete;}{Volume{v2};};
//
// 工具その３（球殻を上下に切り分ける１）を作る
// 直方体を作り、ｘ軸回り４５度(π/4)回転
//
v11 = newv;  Box(v11) = {-lr, 0, 0, 3*lr, 2*ll+2*lr, -3*lr};
Rotate {{1, 0, 0}, {0, 0, 0}, Pi/4} { Volume{v11}; }
Translate {0, -ll2, ll2} { Volume{v11}; }
//
// 工具その４（球殻を上下に切り分ける２）を作る
// 直方体を作り、ｚ軸回り４５度(π/4)回転
//
v12 = newv;  Box(v12) = { 0, 0,lr, -3*lr, 2*ll+2*lr, -3*lr};
Rotate {{0, 0, 1}, {0, 0, 0}, -Pi/4} { Volume{v12}; }
Translate {-ll2, -ll2, 0} { Volume{v12}; }
//
// 球殻（左下部）を切り出す
//
v13 = newv;  BooleanIntersection(v13) = {Volume{v6};}{Volume{v2};};
v14 = newv;  BooleanDifference(v14) = {Volume{v13}; Delete;}{Volume{v11};Delete;};
//
// 球殻（右下部）を切り出す
//
v15 = newv;  BooleanDifference(v15) = {Volume{v6}; Delete;}{Volume{v2};Delete;};
v16 = newv;  BooleanDifference(v16) = {Volume{v15}; Delete;}{Volume{v12};Delete;};
//
// 異常をきたしている球殻（上部）を球殻（左下部）から回転コピー
//
v17 = Rotate{{1,1,-1},{0,0,0},Pi/3*2}{ Duplicata{ Volume{v14}; }};
Coherence;
HealShapes;
//

