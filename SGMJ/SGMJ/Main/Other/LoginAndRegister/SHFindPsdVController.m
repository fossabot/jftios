//
//  SHFindPsdVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/4/4.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHFindPsdVController.h"
#import "UIButton+SHButton.h"
#import "SHLoginModel.h"
#import "SHRedPackageV.h"
#import "SHVerifyIDViewController.h"
#import "SHRegularView.h"

@interface SHFindPsdVController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *psdView;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *psdTF;

@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *showPsdButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (nonatomic, strong) SHRedPackageV *redView;

@property (nonatomic, strong) SHRegularView *regularView;


@end

@implementation SHFindPsdVController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //return
    //SHColorFromHex(0x00a9f0)
    //字体
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
    //导航栏背景色
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    //修改返回按钮
    UIButton * btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0, 0, 30, 44);
    UIImage * bImage = [[UIImage imageNamed: @"returnBack"] resizableImageWithCapInsets: UIEdgeInsetsMake(0, 0, 0, 0)];
    [btn addTarget:self action:@selector(back) forControlEvents: UIControlEventTouchUpInside];
    [btn setImage:bImage forState: UIControlStateNormal];
    UIBarButtonItem *lb = [[UIBarButtonItem alloc] initWithCustomView: btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = - 20;
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, lb];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
    self.navigationController.navigationBar.barTintColor = SHColorFromHex(0x00a9f0);
    
    [self allTFResignFirstResponder];
    [_codeButton sh_stopCountDown];
    [_redView closeRedPackageView];
    
}

- (void)back
{
    
    if (SH_AppDelegate.isPersonLogin) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
//    [self allTFResignFirstResponder];
//    [_codeButton sh_stopCountDown];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];

    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"return"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];

}

- (void)initBaseInfo {
    
    if (self.loginType == SHRegisterStatus) {
        self.navigationItem.title = @"注册";
        [_sureButton setTitle:@"注册" forState:UIControlStateNormal];
    } else if (self.loginType == SHFindPsdStatus) {
        self.navigationItem.title = @"找回密码";
        [_sureButton setTitle:@"确认修改" forState:UIControlStateNormal];
    }
    
    _phoneView.backgroundColor = SHColorFromHex(0xc9e4f9);
    _phoneView.layer.cornerRadius = _phoneView.height / 2;
    _phoneView.clipsToBounds = YES;
    _phoneView.layer.borderWidth = 1;
    _phoneView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _codeView.backgroundColor = SHColorFromHex(0xc9e4f9);
    _codeView.layer.cornerRadius = _codeView.height / 2;
    _codeView.clipsToBounds = YES;
    _codeView.layer.borderWidth = 1;
    _codeView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _psdView.backgroundColor = SHColorFromHex(0xc9e4f9);
    _psdView.layer.cornerRadius = _psdView.height / 2;
    _psdView.clipsToBounds = YES;
    _psdTF.secureTextEntry = YES;
    _psdView.layer.borderWidth = 1;
    _psdView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    [_codeButton setTitleColor:SHColorFromHex(0x4a4c5b) forState:UIControlStateNormal];
    [_sureButton setCornerRadiusWithBackgroundColor:SHColorFromHex(0x00a9f0)];
    //_sureButton.userInteractionEnabled = NO;
    //[_sureButton setCornerRadiusWithBackgroundColor:[UIColor lightGrayColor]];
    

}

//直接返回，不经过登录页
- (void)backAction
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

#pragma mark - button
//获取验证码
- (IBAction)codeButtonClick:(UIButton *)sender {
    if (![self judgePhone:_phoneTF.text]) {
        
    } else {
        [sender sh_beginCountDownWithDuration:SHCountDownSeconds];
        [self getUUID];
        
    }
    
    
}



//隐显密码
- (IBAction)showPsdButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _psdTF.secureTextEntry = NO;
        [sender setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
    } else {
        _psdTF.secureTextEntry = YES;
        [sender setImage:[UIImage imageNamed:@"Shutdown"] forState:UIControlStateNormal];
    }
}

//确认
- (IBAction)sureButtonClick:(UIButton *)sender {
    
    if ([self judgePhoneAndCode]) {
        if (self.loginType == SHRegisterStatus) {                       //注册接口
            [self registerStatueFunction];
        } else if (self.loginType == SHFindPsdStatus) {                 //找回密码接口
            [self findPasswordFunction];
        }
    } else {
    }
   
}


- (IBAction)agreeXieyiButtonClick:(UIButton *)sender {
    
    /*
     

     */
    
    _regularView = [[SHRegularView alloc] init];
    _regularView.titleLabel.text = @"—————— 注册协议 ——————";
    _regularView.textView.text = @"注册协议：\n根据阜阳市家服通家政服务股份有限公司的家服通APP平台制定本协议，协议内容如下：\n\n协议生效日期：自用户下载日开始\n\n• 提示条款\n欢迎您与各家服通平台经营者（详见定义条款）共同签署本《家服通平台服务协议》（下称“本协议”）并使用家服通平台服务！\n\n各服务条款前所列索引关键词仅为帮助您理解该条款表达的主旨之用，不影响或限制本协议条款的含义或解释,为维护您自身权益，建议您仔细阅读各条款具体表述。\n\n[审慎阅读]您在申请注册流程中点击同意本协议之前，应当认真阅读本协议。请您务必审慎阅读、充分理解各条款内容，特别是免除或者限制责任的条款、法律适用和争议解决条款。免除或者限制责任的条款将以粗体下划线标识，您应重点阅读。如您对协议有任何疑问，可向家服通平台客服咨询。\n\n[签约动作】当您按照注册页面提示填写信息、阅读并同意本协议且完成全部注册程序后，即表示您已充分阅读、理解并接受本协议的全部内容，并与家服通达成一致，成为家服通平台“用户”。阅读本协议的过程中，如果您不同意本协议或其中任何条款约定，您应立即停止注册程序。\n\n一、定义\n\n家服通：家服通平台经营者的单称或合称，包括家服通经营者阜阳市家服通家政服务股份有限公司等。\n\n家服通平台服务：家服通基于互联网，以包含家服通平台网站、客户端等在内的各种形态（包括未来技术发展出现的新的服务形态）向您提供的各项服务。\n\n家服通平台规则：包括在所有家服通平台规则频道内已经发布及后续发布的全部规则、解读、公告等内容以及各平台在帮派、论坛、帮助中心内发布的各类规则、实施细则、产品流程说明、公告等。\n\n支付宝公司：指提供支付宝服务的主体支付宝（中国）网络技术有限公司。\n\n关联公司：除家服通外平台经营者的单称或合称。\n\n同一用户：使用同一身份认证信息或经家服通排查认定多个家服通账户的实际控制人为同一人的，均视为同一用户。\n\n二、 协议范围\n\n2.1 签约主体\n\n【平等主体】本协议由您与家服通平台经营者共同缔结，本协议对您与家服通平台经营者均具有合同效力。\n\n【主体信息】家服通平台经营者是指经营家服通平台的各法律主体，您可随时查看家服通平台各网站首页底部公示的证照信息以确定与您履约的家服通主体。本协议项下，家服通平台经营者可能根据家服通平台的业务调整而发生变更，变更后的家服通平台经营者与您共同履行本协议并向您提供服务，家服通平台经营者的变更不会影响您本协议项下的权益。家服通平台经营者还有可能因为提供新的家服通平台服务而新增，如您使用新增的家服通平台服务的，视为您同意新增的家服通平台经营者与您共同履行本协议。发生争议时，您可根据您具体使用的服务及对您权益产生影响的具体行为对象确定与您履约的主体及争议相对方。\n\n2.2补充协议\n\n由于互联网高速发展，您与家服通签署的本协议列明的条款并不能完整罗列并覆盖您与家服通所有权利与义务，现有的约定也不能保证完全符合未来发展的需求。因此，家服通平台法律声明及隐私权政策、家服通平台规则均为本协议的补充协议，与本协议不可分割且具有同等法律效力。如您使用家服通平台服务，视为您同意上述补充协议。\n\n三、 账户注册与使用\n\n3.1 用户资格。\n\n您确认，在您开始注册程序使用家服通平台服务前，您应当具备中华人民共和国法律规定的与您行为相适应的民事行为能力。若您不具备前述与您行为相适应的民事行为能力，则您及您的监护人应依照法律规定承担因此而导致的一切后果。\n\n3.2 账户说明\n\n【账户获得】当您按照注册页面提示填写信息、阅读并同意本协议且完成全部注册程序后，您可获得家服通平台账户并成为家服通平台用户。\n\n家服通平台只允许每位用户使用一个家服通平台账户。如有证据证明或家服通平台有理由相信您存在不当注册或不当使用多个家服通平台账户的情形，家服通平台可采取冻结或关闭账户、取消订单、拒绝提供服务等措施，如给家服通平台及相关方造成损失的，您还应承担赔偿责任。\n\n【账户使用】您有权使用您设置或确认的家服通会员名、邮箱、手机号码（以下简称“账户名称”）及您设置的密码（账户名称及密码合称“账户”）登录家服通平台。\n\n由于您的家服通账户关联您的个人信息及家服通平台商业信息，您的家服通账户仅限您本人使用。未经家服通平台同意，您直接或间接授权第三方使用您家服通账户或获取您账户项下信息的行为无效。如家服通平台判断您家服通账户的使用可能危及您的账户安全及/或家服通平台信息安全的，家服通平台可拒绝提供相应服务或终止本协议。\n\n【账户转让】由于用户账户关联用户信用信息，仅当有法律明文规定、司法裁定或经家服通同意，并符合家服通平台规则规定的用户账户转让流程的情况下，您可进行账户的转让。您的账户一经转让，该账户项下权利义务一并转移。除此外，您的账户不得以任何方式转让，否则家服通平台有权追究您的违约责任，且由此产生的一切责任均由您承担。\n\n【实名认证】作为家服通平台经营者，为使您更好地使用家服通平台的各项服务，保障您的账户安全，家服通可要求您按支付宝公司要求及我国法律规定完成实名认证。\n\n3.3 注册信息管理\n\n3.3.1 真实合法\n\n【信息真实】在使用家服通平台服务时，您应当按家服通平台页面的提示准确完整地提供您的信息（包括您的姓名及电子邮件地址、联系电话、联系地址等），以便家服通或其他用户与您联系。您了解并同意，您有义务保持您提供信息的真实性及有效性。\n\n【会员名的合法性】您设置的家服通会员名不得违反国家法律法规及家服通网规则关于会员名的管理规定，否则家服通可回收您的家服通会员名。家服通会员名的回收不影响您以邮箱、手机号码登录家服通平台并使用家服通平台服务。\n\n3.3.2 更新维护\n\n您应当及时更新您提供的信息，在法律有明确规定要求家服通作为平台服务提供者必须对部分用户（如平台卖家等）的信息进行核实的情况下，家服通将依法不时地对您的信息进行检查核实，您应当配合提供最新、真实、完整、有效的信息。\n\n如家服通按您最后一次提供的信息与您联系未果、您未按家服通的要求及时提供信息、您提供的信息存在明显不实或行政司法机关核实您提供的信息无效的，您将承担因此对您自身、他人及家服通造成的全部损失与不利后果。家服通可向您发出询问或要求整改的通知，并要求您进行重新认证，直至中止、终止对您提供部分或全部家服通平台服务，家服通对此不承担责任。\n\n3.4 账户安全规范\n\n【账户安全保管义务】您的账户为您自行设置并由您保管，家服通任何时候均不会主动要求您提供您的账户密码。因此，建议您务必保管好您的账户， 并确保您在每个上网时段结束时退出登录并以正确步骤离开家服通平台。\n\n账户因您主动泄露或因您遭受他人攻击、诈骗等行为导致的损失及后果，家服通并不承担责任，您应通过司法、行政等救济途径向侵权行为人追偿。\n\n【账户行为责任自负】除家服通存在过错外，您应对您账户项下的所有行为结果（包括但不限于在线签署各类协议、发布信息、购买商品及服务及披露信息等）负责。\n\n【日常维护须知】如发现任何未经授权使用您账户登录家服通平台或其他可能导致您账户遭窃、遗失的情况，建议您立即通知家服通，并授权家服通将该信息同步给支付宝及家服通平台。您理解家服通对您的任何请求采取行动均需要合理时间，且家服通应您请求而采取的行动可能无法避免或阻止侵害后果的形成或扩大，除家服通存在法定过错外，家服通不承担责任。\n\n四、家服通平台服务及规范\n\n【服务概况】您有权在家服通平台上享受或服务的销售与推广、服务的购买与评价、交易争议处理等服务。家服通提供的服务内容众多，具体您可登录家服通平台浏览。\n\n4.1服务的销售与推广\n\n【服务信息发布】通过家服通提供的服务，您有权通过文字、图片、视频、音频等形式在家服通平台上发布商品及/或服务信息、招揽和物色交易对象、达成交易。\n\n【禁止销售范围】您应当确保您对您在家服通平台上发布的服务享有相应的权利，您不得在家服通平台上提供以下服务：\n\n（一）国家禁止或限制的；\n\n（二）侵犯他人知识产权或其它合法权益的；\n\n（三）家服通平台规则、公告、通知或各平台与您单独签署的协议中已明确说明不适合在家服通平台上销售及/或提供的。\n\n【交易秩序保障】您应当遵守诚实信用原则，确保您所发布的服务信息真实、与您实际所提供的服务相符，并在交易过程中切实履行您的交易承诺。\n\n您应当维护家服通平台市场良性竞争秩序，不得贬低、诋毁竞争对手，不得干扰家服通平台上进行的任何交易、活动，不得以任何不正当方式提升或试图提升自身的信用度，不得以任何方式干扰或试图干扰家服通平台的正常运作。\n\n【促销及推广】您有权自行决定商品及/或服务的促销及推广方式，家服通亦为您提供了形式丰富的促销推广工具。您的促销推广行为应当符合国家相关法律法规及家服通平台的要求。\n\n【依法纳税】依法纳税是每一个公民、企业应尽的义务，您应对销售额/营业额超过法定免征额部分及时、足额地向税务主管机关申报纳税。\n\n4.3商品及/或服务的购买与评价\n\n【商品及/或服务的购买】当您在家服通平台购买商品及/或服务时，请您务必仔细确认所购商品的品名、价格、数量、型号、规格、尺寸或服务的时间、内容、限制性要求等重要事项，并在下单时核实您的联系地址、电话、收货人等信息。如您填写的收货人非您本人，则该收货人的行为和意思表示产生的法律后果均由您承担。\n\n您的购买行为应当基于真实的消费需求，不得存在对商品及/或服务实施恶意购买、恶意维权等扰乱家服通平台正常交易秩序的行为。基于维护家服通平台交易秩序及交易安全的需要，家服通发现上述情形时可主动执行关闭相关交易订单等操作。\n\n【一口价与拍卖】家服通平台存在“一口价”和“拍卖”两种出价形式。在拍卖形式下，您理解家服通平台并非《中华人民共和国拍卖法》规定的“拍卖人”， 家服通平台仅为用户以竞价形式购买商品及/或服务的在线交易场所。\n\n【评价】您有权在家服通平台提供的评价系统中对与您达成交易的其他用户商品及/或服务进行评价。您应当理解，您在家服通平台的评价信息是公开的，如您不愿意在评价信息中向公众披露您的身份信息，您有权选择通过匿名形式发表评价内容。\n\n您的所有评价行为应遵守家服通平台规则的相关规定，评价内容应当客观真实，不应包含任何污言秽语、色情低俗、广告信息及法律法规与本协议列明的其他禁止性信息；您不应以不正当方式帮助他人提升信用或利用评价权利对其他用户实施威胁、敲诈勒索。家服通可按照家服通平台规则的相关规定对您实施上述行为所产生的评价信息进行删除或屏蔽。\n\n4.4交易争议处理\n\n【交易争议处理途径】您在家服通平台交易过程中与其他用户发生争议的，您或其他用户中任何一方均有权选择以下途径解决：\n\n（一）与争议相对方自主协商；\n\n（二）使用家服通平台提供的争议调处服务；\n\n（三）请求消费者协会或者其他依法成立的调解组织调解；\n\n（四）向有关行政部门投诉；\n\n（五）根据与争议相对方达成的仲裁协议（如有）提请仲裁机构仲裁；\n\n（六）向人民法院提起诉讼。\n\n【平台调处服务】如您依据家服通平台规则使用使用家服通平台的争议调处服务，则表示您认可并愿意履行家服通平台的客服或大众评审员（“调处方”）作为独立的第三方根据其所了解到的争议事实并依据家服通平台规则所作出的调处决定（包括调整相关订单的交易状态、判定将争议款项的全部或部分支付给交易一方或双方等）。在家服通平台调处决定作出前，您可选择上述（三）、（四）、（五）、（六）途径（下称“其他争议处理途径”）解决争议以中止家服通平台的争议调处服务。\n\n如您对调处决定不满意，您仍有权采取其他争议处理途径解决争议，但通过其他争议处理途径未取得终局决定前，您仍应先履行调处决定。\n\n4.5费用\n\n家服通为家服通平台向您提供的服务付出了大量的成本，除家服通平台明示的收费业务外，家服通向您提供的服务目前是免费的。如未来家服通向您收取合理费用，家服通会采取合理途径并以足够合理的期限提前通过法定程序并以本协议第八条约定的方式通知您，确保您有充分选择的权利。\n\n4.6责任限制\n\n【不可抗力及第三方原因】家服通依照法律规定履行基础保障义务，但对于下述原因导致的合同履行障碍、履行瑕疵、履行延后或履行内容变更等情形，家服通并不承担相应的违约责任：\n\n（一）因自然灾害、罢工、暴乱、战争、政府行为、司法行政命令等不可抗力因素；\n\n（二）因电力供应故障、通讯网络故障等公共服务因素或第三人因素；\n\n（三）在家服通已尽善意管理的情况下，因常规或紧急的设备与系统维护、设备与系统故障、网络信息与数据安全等因素。\n\n【海量信息】家服通仅向您提供家服通平台服务，您了解家服通平台上的信息系用户自行发布，且可能存在风险和瑕疵。鉴于家服通平台具备存在海量信息及信息网络环境下信息与实物相分离的特点，家服通无法逐一审查商品及/或服务的信息，无法逐一审查交易所涉及的商品及/或服务的质量、安全以及合法性、真实性、准确性，对此您应谨慎判断。\n\n【调处决定】您理解并同意，在争议调处服务中，家服通平台的客服、大众评审员并非专业人士，仅能以普通人的认知对用户提交的凭证进行判断。因此，除存在故意或重大过失外，调处方对争议调处决定免责。\n\n五、 用户信息的保护及授权\n\n5.1个人信息的保护\n\n家服通非常重视用户个人信息（即能够独立或与其他信息结合后识别用户身份的信息）的保护，在您使用家服通提供的服务时，您同意家服通按照在家服通平台上公布的隐私权政策收集、存储、使用、披露和保护您的个人信息。家服通希望通过隐私权政策向您清楚地介绍家服通对您个人信息的处理方式，因此家服通建议您完整地阅读隐私权政策（点击此处或点击家服通平台首页底部链接），以帮助您更好地保护您的隐私权。\n\n5.2非个人信息的保证与授权\n\n【信息的发布】您声明并保证，您对您所发布的信息拥有相应、合法的权利。否则，家服通可对您发布的信息依法或依本协议进行删除或屏蔽。\n\n【禁止性信息】您应当确保您所发布的信息不包含以下内容：\n\n一）违反国家法律法规禁止性规定的；\n\n（二）政治宣传、封建迷信、淫秽、色情、赌博、暴力、恐怖或者教唆犯罪的；\n\n（三）欺诈、虚假、不准确或存在误导性的；\n\n（四）侵犯他人知识产权或涉及第三方商业秘密及其他专有权利的；\n\n（五）侮辱、诽谤、恐吓、涉及他人隐私等侵害他人合法权益的；\n\n（六）存在可能破坏、篡改、删除、影响家服通平台任何系统正常运行或未经授权秘密获取家服通平台及其他用户的数据、个人资料的病毒、木马、爬虫等恶意软件、程序代码的；\n\n（七）其他违背社会公共利益或公共道德或依据相关家服通平台协议、规则的规定不适合在家服通平台上发布的。\n\n【授权使用】对于您提供及发布除个人信息外的文字、图片、视频、音频等非个人信息，在版权保护期内您免费授予家服通及其关联公司、支付宝公司获得全球排他的许可使用权利及再授权给其他第三方使用的权利。您同意家服通及其关联公司、支付宝公司存储、使用、复制、修订、编辑、发布、展示、翻译、分发您的非个人信息或制作其派生作品，并以已知或日后开发的形式、媒体或技术将上述信息纳入其它作品内。\n\n为方便您使用家服通平台、支付宝等其他相关服务，您授权家服通将您在账户注册和使用家服通平台服务过程中提供、形成的信息传递给家服通平台、支付宝等其他相关服务提供者，或从家服通平台、支付宝等其他相关服务提供者获取您在注册、使用相关服务期间提供、形成的信息。\n\n六、 用户的违约及处理\n\n6.1 违约认定\n\n发生如下情形之一的，视为您违约：\n\n（一）使用家服通平台服务时违反有关法律法规规定的；\n\n（二）违反本协议或本协议补充协议（即本协议第2.2条）约定的。\n\n为适应电子商务发展和满足海量用户对高效优质服务的需求，您理解并同意，家服通可在家服通平台规则中约定违约认定的程序和标准。如：家服通可依据您的用户数据与海量用户数据的关系来认定您是否构成违约；您有义务对您的数据异常现象进行充分举证和合理解释，否则将被认定为违约。\n\n6.2 违约处理措施\n\n【信息处理】您在家服通平台上发布的信息构成违约的，家服通可根据相应规则立即对相应信息进行删除、屏蔽处理或对您的商品进行下架、监管。\n\n【行为限制】您在家服通平台上实施的行为，或虽未在家服通平台上实施但对家服通平台及其用户产生影响的行为构成违约的，家服通可依据相应规则对您执行账户扣分、限制参加营销活动、中止向您提供部分或全部服务、划扣违约金等处理措施。如您的行为构成根本违约的，家服通可查封您的账户，终止向您提供服务。\n\n【支付宝账户处理】当您违约的同时存在欺诈、售假、盗用他人账户等特定情形或您存在危及他人交易安全或账户安全风险时，家服通会依照您行为的风险程度指示支付宝公司对您的支付宝账户采取取消收款、资金止付等强制措施。\n\n【处理结果公示】家服通可将对您上述违约行为处理措施信息以及其他经国家行政或司法机关生效法律文书确认的违法信息在家服通平台上予以公示。\n\n6.3赔偿责任\n\n如您的行为使家服通及/或其关联公司、支付宝公司遭受损失（包括自身的直接经济损失、商誉损失及对外支付的赔偿金、和解款、律师费、诉讼费等间接经济损失），您应赔偿家服通及/或其关联公司、支付宝公司的上述全部损失。\n\n如您的行为使家服通及/或其关联公司、支付宝公司遭受第三人主张权利，家服通及/或其关联公司、支付宝公司可在对第三人承担金钱给付等义务后就全部损失向您追偿。\n\n如因您的行为使得第三人遭受损失或您怠于履行调处决定、家服通及/或其关联公司出于社会公共利益保护或消费者权益保护目的，可指示支付宝公司自您的支付宝账户中划扣相应款项进行支付。如您的支付宝余额或保证金不足以支付相应款项的，您同意委托家服通使用自有资金代您支付上述款项，您应当返还该部分费用并赔偿因此造成家服通的全部损失。\n\n您同意家服通指示支付宝公司自您的支付宝账户中划扣相应款项支付上述赔偿款项。如您支付宝账户中的款项不足以支付上述赔偿款项的，家服通及/或关联公司可直接抵减您在家服通及/或其关联公司其它协议项下的权益，并可继续追偿。\n\n6.4特别约定\n\n【商业贿赂】如您向家服通及/或其关联公司的雇员或顾问等提供实物、现金、现金等价物、劳务、旅游等价值明显超出正常商务洽谈范畴的利益，则可视为您存在商业贿赂行为。发生上述情形的，家服通可立即终止与您的所有合作并向您收取违约金及/或赔偿金，该等金额以家服通因您的贿赂行为而遭受的经济损失和商誉损失作为计算依据。\n\n【关联处理】如您因严重违约导致家服通终止本协议时，出于维护平台秩序及保护消费者权益的目的，家服通及/或其关联公司可对与您在其他协议项下的合作采取中止甚或终止协议的措施，并以本协议第八条约定的方式通知您。\n\n如家服通与您签署的其他协议及家服通及/或其关联公司、支付宝公司与您签署的协议中明确约定了对您在本协议项下合作进行关联处理的情形，则家服通出于维护平台秩序及保护消费者权益的目的，可在收到指令时中止甚至终止协议，并以本协议第八条约定的方式通知您。\n\n七、 协议的变更\n\n家服通可根据国家法律法规变化及维护交易秩序、保护消费者权益需要，不时修改本协议、补充协议，变更后的协议、补充协议（下称“变更事项”）将通过法定程序并以本协议第八条约定的方式通知您。\n\n如您不同意变更事项，您有权于变更事项确定的生效日前联系家服通反馈意见。如反馈意见得以采纳，家服通将酌情调整变更事项。\n\n如您对已生效的变更事项仍不同意的，您应当于变更事项确定的生效之日起停止使用家服通平台服务，变更事项对您不产生效力；如您在变更事项生效后仍继续使用家服通平台服务，则视为您同意已生效的变更事项。\n\n八、 通知\n\n8.1有效联系方式\n\n您在注册成为家服通平台用户，并接受家服通平台服务时，您应该向家服通提供真实有效的联系方式（包括您的电子邮件地址、联系电话、联系地址等），对于联系方式发生变更的，您有义务及时更新有关信息，并保持可被联系的状态。\n\n您在注册家服通平台用户时生成的用于登陆家服通平台接收站内信、系统消息和阿里旺旺即时信息的会员账号（包括子账号），也作为您的有效联系方式。\n\n家服通将向您的上述联系方式的其中之一或其中若干向您送达各类通知，而此类通知的内容可能对您的权利义务产生重大的有利或不利影响，请您务必及时关注。\n\n您有权通过您注册时填写的手机号码或者电子邮箱获取您感兴趣的商品广告信息、促销优惠等商业性信息；您如果不愿意接收此类信息，您有权通过家服通提供的相应的退订功能进行退订。\n\n8.2 通知的送达\n\n家服通通过上述联系方式向您发出通知，其中以电子的方式发出的书面通知，包括但不限于在家服通平台公告，向您提供的联系电话发送手机短信，向您提供的电子邮件地址发送电子邮件，向您的账号发送旺旺信息、系统消息以及站内信信息，在发送成功后即视为送达；以纸质载体发出的书面通知，按照提供联系地址交邮后的第五个自然日即视为送达。\n\n对于在家服通平台上因交易活动引起的任何纠纷，您同意司法机关（包括但不限于人民法院）可以通过手机短信、电子邮件等现代通讯方式或邮寄方式向您送达法律文书（包括但不限于诉讼文书）。您指定接收法律文书的手机号码、电子邮箱等联系方式为您在家服通平台注册、更新时提供的手机号码、电子邮箱联系方式，司法机关向上述联系方式发出法律文书即视为送达。您指定的邮寄地址为您的法定联系地址或您提供的有效联系地址。\n\n您同意司法机关可采取以上一种或多种送达方式向您达法律文书，司法机关采取多种方式向您送达法律文书，送达时间以上述送达方式中最先送达的为准。\n\n您同意上述送达方式适用于各个司法程序阶段。如进入诉讼程序的，包括但不限于一审、二审、再审、执行以及督促程序等。\n\n你应当保证所提供的联系方式是准确、有效的，并进行实时更新。如果因提供的联系方式不确切，或不及时告知变更后的联系方式，使法律文书无法送达或未及时送达，由您自行承担由此可能产生的法律后果。\n\n九、 协议的终止\n\n9.1 终止的情形\n\n【用户发起的终止】您有权通过以下任一方式终止本协议：\n\n（一）在满足家服通网公示的账户注销条件时您通过网站自助服务注销您的账户的；\n\n（二）变更事项生效前您停止使用并明示不愿接受变更事项的；\n\n（三）您明示不愿继续使用家服通平台服务，且符合家服通网终止条件的。\n\n【家服通发起的终止】出现以下情况时，家服通可以本协议第八条的所列的方式通知您终止本协议：\n\n（一）您违反本协议约定，家服通依据违约条款终止本协议的；\n\n（二）您盗用他人账户、发布违禁信息、骗取他人财物、售假、扰乱市场秩序、采取不正当手段谋利等行为，家服通依据家服通平台规则对您的账户予以查封的；\n\n（三）除上述情形外，因您多次违反家服通平台规则相关规定且情节严重，家服通依据家服通平台规则对您的账户予以查封的；\n\n（四）您的账户被家服通依据本协议回收的；\n\n（五）您在支付宝或家服通平台有欺诈、发布或销售假冒伪劣/侵权商品、侵犯他人合法权益或其他严重违法违约行为的；\n\n（六）其它应当终止服务的情况。\n\n9.2 协议终止后的处理\n\n【用户信息披露】本协议终止后，除法律有明确规定外，家服通无义务向您或您指定的第三方披露您账户中的任何信息。\n\n【家服通权利】本协议终止后，家服通仍享有下列权利：\n\n（一）继续保存您留存于家服通平台的本协议第五条所列的各类信息；\n\n（二）对于您过往的违约行为，家服通仍可依据本协议向您追究违约责任。\n\n【交易处理】本协议终止后，对于您在本协议存续期间产生的交易订单，家服通可通知交易相对方并根据交易相对方的意愿决定是否关闭该等交易订单；如交易相对方要求继续履行的，则您应当就该等交易订单继续履行本协议及交易订单的约定，并承担因此产生的任何损失或增加的任何费用。\n\n十、 法律适用、管辖与其他\n\n【法律适用】本协议之订立、生效、解释、修订、补充、终止、执行与争议解决均适用中华人民共和国大陆地区法律；如法律无相关规定的，参照商业惯例及/或行业惯例。\n\n【管辖】您因使用家服通平台服务所产生及与家服通平台服务有关的争议，由家服通与您协商解决。协商不成时，任何一方均可向被告所在地人民法院提起诉讼。\n\n【可分性】本协议任一条款被视为废止、无效或不可执行，该条应视为可分的且并不影响本协议其余条款的有效性及可执行性。\n\n家服通法律声明及隐私政策\n\n法律声明\n\n访问、浏览或使用家服通平台，表明您已阅读、理解并同意接受以下条款的约束，并遵守所有适用的法律和法规。您一旦使用家服通，则须秉着诚信的原则遵守以下条款。\n\n一般原则\n\n以下规则适用于所有家服通用户或浏览者，家服通可能随时修改这些条款。您应经常访问本页面以了解当前的条款，因为这些条款与您密切相关。这些条款的某些条文也可能被家服通平台中某些页面上或某些具体服务明确指定的法律通告或条款所取代，您应该了解这些内容，一旦接受本条款，即意味着您已经同时详细阅读并接受了这些被引用或取代的条款。\n\n权利说明\n\n阜阳市家服通家政服务股份有限公司及其关联公司（以下称“本公司”)对其发行的或与合作公司共同发行的包括但不限于提供的软件及相关产品或服务的全部内容，享有知识产权，受法律保护。如果相关内容未含权利声明，并不代表本公司对其不享有权利和不主张权利，您应根据法律、法规及诚信原则尊重权利人的合法权益并合法使用该内容。\n\n未经阜阳市家服通家政服务股份有限公司书面许可，任何单位及个人不得以任何方式或理由对上述软件、产品、服务、信息、文字的任何部分进行使用、复制、修改、抄录、传播或与其它产品捆绑使用、销售,或以超级链路连接或传送、存储于信息检索系统或者其他任何商业目的的使用，但对于非商业目的的、个人使用的下载或打印（未作修改，且须保留该内容中的版权说明或其他所有权的说明）除外。\n\n上述软件中使用和显示的商标和标识（以下统称“商标”)是阜阳市家服通家政服务股份有限公司及其关联公司在服务及其它相关领域内注册和未注册的有关商标，受法律保护，但注明属于其他方拥有的商标、标志、商号除外。该等软件中所载的任何内容，未经阜阳市家服通家政服务股份有限公司书面许可，任何人不得以任何方式使用家服通名称及相关商标、标识。\n\n用户信息\n\n为家服通提供相应服务之必须，您以自愿填写的方式提供注册所需的姓名、性别、电话以及其他类似的个人信息，则表示您已经了解并接受您个人信息的用途，同意家服通为实现该特定目的使用您的个人信息。除此个人信息之外，其他任何您发送或提供给家服通的材料、信息或文本(以下统称信息)均将被视为非保密和非专有的。家服通对这些信息不承担任何义务。同时如果您提交时没有特别声明的，可视为同意家服通及其授权人可以因商业或非商业的目的复制、透露、分发、合并和以其他方式利用这些信息和所有数据、图像、声音、文本及其他内容。您可阅读下面的家服通隐私政策以了解更加详细的内容。\n\n责任限制声明\n\n不论在何种情况下，家服通对由于信息网络设备维护、信息网络连接故障、智能终端、通讯或其他系统的故障、电力故障、罢工、劳动争议、暴乱、起义、骚乱、火灾、洪水、风暴、爆炸、战争、政府行为、司法行政机关的命令、其他不可抗力或第三方的不作为而造成的不能服务或延迟服务不承担责任。\n\n无论在任何情况下（包括但不限于疏忽原因），由于使用家服通上的信息或由家服通平台链接的信息，或其他与家服通平台链接的网站信息，对您或他人所造成任何的损失或损害（包括直接、间接、特别或后果性的损失或损害，例如收入或利润之损失，智能终端系统之损坏或数据丢失等后果），均由使用者自行承担责任（包括但不限于疏忽责任）。\n\n家服通所载的信息，包括但不限于文本、图片、数据、观点、网页或链接，虽然力图准确和详尽，但家服通并不就其所包含的信息和内容的准确、完整、充分和可靠性做任何承诺。家服通表明不对这些信息和内容的错误或遗漏承担责任，也不对这些信息和内容作出任何明示或默示的、包栝但不限于没有侵犯犯第三方权利、质量和没有智能终端病毒的保证。\n\n第三方链接\n\n家服通可能保留有第三方网站或网址的链接，访问这些链接将由用户自己作出决定，家服通并不就这些链接上所提供的任何信息、数据、观点、图片、陈述或建议的准确性、完整性、充分性和可靠性提供承诺或保证。家服通没有审查过任何第三方网站，对这些网站及其内容不进行控制，也不负任何责任。如果您决定访问任何与本站链接的第三方网站，其可能带来的结果和风险全部由您自己承担。\n\n适用法律和管辖权\n\n通过访问家服通平台或使用家服通提供的服务，即表示您同意该访问或服务受中华人民共和国法律的约束，且您同意受中华人民共和国法院的管辖。访问或接受服务过程中发生的争议应当协商解决，协商不成的，各方一致同意至阜阳市家服通家政服务股份有限公司住所所在地有管辖权的法院诉讼解决。\n\n隐私政策\n\n家服通非常重视对您的个人隐私保护，我们将按照本隐私政策（以下称“本政策”)收集、使用、共享和保护您的个人信息。在您使用家服通的产品及服务前，请您仔细阅读并全面了解本政策。如果您是未成年人，您的监护人需要仔细阅读本政策并同意您依照本政策使用我们的产品及服务。对于本政策中与您的权益存在重大关系的条款，我们已将字体加粗以提示您注意。当您浏览、访问家服通平台及/或使用家服通的任一产品或服务时，即表示您已经同意我们按照本政策来收集、使用、共享和保护您的个人信息。\n\n我们收集、使用、共享和保护您的个人信息，是在遵守国家法律法规规定的前提下，出于向您提供家服通的产品及服务并不断提升产品及服务质量的目的，包括但不限于支持我们开展家服通产品及服务相关的市场活动、完善现有产品及服务功能、开发新产品或新服务。\n\n信息的收集范围\n\n您授权我们收集您的以下个人信息：\n\n身份识别信息，包括但不限于您的姓名、身份证明、联系地址、电话号码、生物特征信息；\n\n您所处的地理位置及目的地信息；\n\n平台操作信息，包括但不限于您的IP地址、设备型号、设备标识符、操作系统版本信息；\n\n支付信息，包括但不限于您的支付时间、支付金额、支付工具、银行账户及支付账户信息；\n\n个人信用信息，包括但不限于关于您的任何信用状况、信用分、信用报告信息；\n\n其他根据我们具体产品及服务的需要而收集的您的个人信息，包括但不限于您对我们及我们的产品或服务的意见、建议、您曾经使用或经常使用的移动应用软件以及使用场景和使用习惯等信息。\n\n信息的收集方法\n\n您授权我们通过以下方法收集您的个人信息：\n\n我们将收集和储存在您浏览、访问家服通平台及/或使用家服通的产品或服务时主动向我们提供的信息；\n\n我们将收集和储存我们在向您提供家服通的产品或服务的过程中记录的与您有关的信息；\n\n我们将收集和储存您通过我们的客服人员及/或其他渠道主动提交或反馈的信息；\n\n我们将向关联公司、商业合作伙伴及第三方独立资料来源，收集和储存其合法获得的与您有关的信息；\n\n我们将向依法设立的征信机构査询您的相关信用信息，包括但不限于任何信用分、信用报告等。\n\n信息的用途\n\n您授权我们出于以下用途使用您的个人信息：\n\n向您提供家服通的产品及服务，并进行家服通相关网站及APP的管理和优化；\n\n提升和改善家服通现有产品及服务的功能和质量，包括但不限于产品及服务内容的个性化定制及更新；\n\n开展家服通产品及服务相关的市场活动，向您推送最新的市场活动信息及优惠方案；\n\n设计、开发、推广全新的产品及服务；\n\n提高家服通产品及服务安全性，包括但不限于身份验证、客户服务、安全防范、诈骗监测、存档和备份；\n\n协助行政机关、司法机构等有权机关开展调査，并遵守适用法律法规及其他向有权机关承诺之义务；\n\n在收集信息之时所通知您的用途以及与上述任何用途有关的其他用途；\n\n此外，我们可能向您发送与上述用途有关的信息和通知，包括但不限于为保证服务完成所必须的验证码、使用产品或服务时所必要的推送通知、关于家服通产品或服务的新闻以及市场活动及优惠促销信息。\n\n信息的共享\n\n我们对您的个人信息承担保密义务，但您授权我们在下列情况下将您的信息与第三方共享：\n\n为了提升我们的产品及服务质量或向您提供全新的产品及服务，我们会在关联公司内部共享您的相关信息，也可能将我们收集的信息提供给第三方用于分析和统计；\n\n如果您通过家服通平台使用的某些产品及服务是由我们的合作伙伴提供的，或是由我们与合作伙伴或供应商共同提供的，我们将与其共享向您提供相应产品及服务所必需的信息；\n\n为了与第三方开展联合推广活动，我们可能与其共享开展活动所必需的以及在活动过程中产生的相关信息；\n\n为了维护您的合法权益，在协助处理与您有关的交易纠纷或争议时，我们会向您的交易相对方或存在利害关系的第三方提供解决交易纠纷或争议所必需的信息；\n\n根据法律法规的规定及商业惯例，我们需要接受第三方的审计或尽职调査时，可能向其提供您的相关信息；\n\n根据法律法规的规定或行政机关、司法机构等有权机关要求，我们会向其提供您的相关信息；\n\n其他经您同意或授权可以向第三方提供您的个人信息的情况。\n\n信息的安全及保护措施\n\n我们及我们的关联公司将采用严格的安全制度以及行业通行的安全技术和程序来确保您的个人信息不被丢失、泄露、毀损或滥用。我们的员工及服务外包人员将受到保密协议的约束，同时还将受到数据信息的权限控制和操作监控。\n\n请您注意，任何安全系统都存在可能的及未知的风险。\n\n您的交易相对方、您访问的第三方网站经营者、您使用的第三方服务提供者和通过我们获取您的个人信息的第三方可能有自己的隐私权保护政策以及获取您个人信息的方法和措施，这些第三方的隐私权保护政策、获取个人信息的方法和措施将不会受到我们的控制。虽然我们将与可能接触到您的个人信息的我们的合作方及供应商等第三方签署保密协议并尽合理的努力督促其履行保密义务，但我们无法保证第三方一定会按照我们的要求采取保密措施，我们亦不对第三方的行为及后果承担任何责任。\n\n作为用户，您可根据您的意愿决定是否使用家服通平台的服务，是否主动提供个人信息。同时，您可以查看您提供给我们的个人信息。如果您希望删除或更正您的个人信息，请联系我们的客服人员。\n\n如果我们监测到您将家服通的产品及服务以及相关信息用于欺诈或非法目的，我们将会采取相应措施，包括但不限于中止或终止向您提供任何产品或服务。\n\n本协议最终解释权归阜阳市家服通家政服务股份有限公司所有";
    [_regularView showRegularView];
    
    
}


//验证码之前获取uuid
- (void)getUUID {
    SHWeakSelf
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SH_SecretAuthUrl params:nil success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 0) {
            NSDictionary *dict = nil;
            if (self.loginType == SHRegisterStatus) {
                dict = @{
                         @"mobile":_phoneTF.text,
                         @"type":@"4",
                         @"uuid":JSON[@"uuid"]
                         };
            } else if (self.loginType == SHFindPsdStatus) {
                dict = @{
                         @"mobile":_phoneTF.text,
                         @"type":@"6",
                         @"uuid":JSON[@"uuid"]
                         };
            }
            
            [weakSelf getCodeFunctionWithDict:dict];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}

//获取验证码接口
- (void)getCodeFunctionWithDict:(NSDictionary *)dict
{
    SHLog(@"%@", dict)
    //获取验证码接口
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHMessageUrl params:dict success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%@", msg)
        SHLog(@"%d", code)
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"短信已成功发送到您的手机上" withSecond:2.0];
        } else {
            [MBProgressHUD showMBPAlertView:msg withSecond:2.0];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMBPAlertView:@"获取验证码失败" withSecond:2.0];
    }];
}

//注册
- (void)registerStatueFunction
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"mobile":_phoneTF.text,
                          @"password":_psdTF.text,
                          @"code":_codeTF.text,
                          @"city":SH_AppDelegate.personInfo.city,
                          @"lon":@(SH_AppDelegate.personInfo.longitude),
                          @"lat":@(SH_AppDelegate.personInfo.latitude)
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHRegisterUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        SHLog(@"%@", JSON)
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"注册成功" withSecond:2.0];
            
            SHLoginModel *loginModel = [SHLoginModel mj_objectWithKeyValues:JSON];
            [weakSelf handleUserInfo:loginModel isThreeLogin:NO];
            [weakSelf uploadRegisterID];
            //登陆成功通知
            NSDictionary *dic = JSON;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil userInfo:dic];
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            SHLog(@"%d", loginModel.isRedCash)
            //注册成功之后根据是否返回红包-->登录状态
//            if (loginModel.isRedCash == 1) {
//                _redView = [[SHRedPackageV alloc] init];
//                _redView.moneyLabel.text = loginModel.money;
//                [_redView.button setTitle:@"实名认证" forState:UIControlStateNormal];
//                _redView.redPacBlock = ^(NSString *buttonTitle) {
//                    SHLog(@"%@", buttonTitle)
//                    [weakSelf dealWithButtonTitleWithRedPackage:buttonTitle];
//                };
//                [_redView showRedPackageView];
//            }
            
        } else {
            [MBProgressHUD showError:msg];
        }
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  根据红包文字处理
 */
- (void)dealWithButtonTitleWithRedPackage:(NSString *)title
{
    if ([title isEqualToString:@"实名认证"]) {
        SHVerifyIDViewController *vc = [[SHVerifyIDViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


//找回密码
- (void)findPasswordFunction
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"mobile":_phoneTF.text,
                          @"code":_codeTF.text,
                          @"newPassword":_psdTF.text
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHForgetPsdUrl params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"修改密码成功" withSecond:2.0];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:msg];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)handleUserInfo:(SHLoginModel *)loginModel isThreeLogin:(BOOL)isThreeLogin {
    if (isThreeLogin) {
        
    } else {
        
        SH_AppDelegate.tokenMap.token = loginModel.tokenMap.token;
        SH_AppDelegate.tokenMap.userId = loginModel.tokenMap.userId;
        
        SH_AppDelegate.userData.afterSalesNum = loginModel.userData.afterSalesNum;
        SH_AppDelegate.userData.balance = loginModel.userData.balance;
        SH_AppDelegate.userData.couponNum = loginModel.userData.couponNum;
        SH_AppDelegate.userData.evaluationNum = loginModel.userData.evaluationNum;
        SH_AppDelegate.userData.fansNum = loginModel.userData.fansNum;
        SH_AppDelegate.userData.followNum = loginModel.userData.followNum;
        SH_AppDelegate.userData.initNum = loginModel.userData.initNum;
        SH_AppDelegate.userData.receiveNum = loginModel.userData.receiveNum;
        
        SH_AppDelegate.personInfo.userId = loginModel.tokenMap.userId;
        SH_AppDelegate.personInfo.avatar = loginModel.user.avatar;
        SH_AppDelegate.personInfo.mobile = loginModel.user.mobile;
        SH_AppDelegate.personInfo.nickName = loginModel.user.nickName;
        SH_AppDelegate.personInfo.introduce = loginModel.user.introduce;
        SH_AppDelegate.personInfo.sex = loginModel.user.sex;
        SH_AppDelegate.personInfo.birthday = loginModel.user.birthday;
        SH_AppDelegate.personInfo.password = loginModel.user.password;
        SH_AppDelegate.personInfo.realName = loginModel.user.realName;
        SH_AppDelegate.personInfo.city = loginModel.user.city;
        SH_AppDelegate.personInfo.longitude = loginModel.user.longitude;
        SH_AppDelegate.personInfo.latitude = loginModel.user.latitude;
        SH_AppDelegate.personInfo.isVerified = loginModel.user.isVerified;
        SH_AppDelegate.personInfo.volume = 1.0;
        
        [[EMClient sharedClient] loginWithUsername:loginModel.user.mobile password:@"123456" completion:^(NSString *aUsername, EMError *aError) {
            if (!aError) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
                
            }
        }];
    }
}

//上传registerID，极光
- (void)uploadRegisterID
{
    if (SH_AppDelegate.personInfo.registerID) {
        NSDictionary *dic = @{
                              @"type":@"IOS",
                              @"registerId":SH_AppDelegate.personInfo.registerID
                              };
        SHLog(@"%@", dic)
        [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHRegisterIDUrl params:dic success:^(id JSON, int code, NSString *msg) {
            SHLog(@"%d", code)
            SHLog(@"%@", msg)
        } failure:^(NSError *error) {
            
        }];
    }
    
}

//获取验证码之前判断手机号
- (BOOL)judgePhone:(NSString *)phone {
    if ([NSString isEmpty:phone]) {
        [MBProgressHUD showMBPAlertView:@"请输入手机号" withSecond:1.5];
        return NO;
    }
    if (![NSString isOKPhoneNumber:phone]) {
        [MBProgressHUD showMBPAlertView:@"请输入正确的手机号" withSecond:1.5];
        return NO;
    }
    return YES;
}

//登录确认之前判断手机号和验证码，密码
- (BOOL)judgePhoneAndCode {
    if ([NSString isEmpty:_phoneTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入手机号" withSecond:1.5];
        return NO;
    }
    if (![NSString isOKPhoneNumber:_phoneTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入正确的手机号" withSecond:1.5];
        return NO;
    }
    //判断密码是否为空
    if ([NSString isEmpty:_codeTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入验证码" withSecond:1.5];
        return NO;
    }
    if ([NSString isEmpty:_psdTF.text]) {
        [MBProgressHUD showMBPAlertView:@"请输入密码" withSecond:1.5];
        return NO;
    }
    return YES;
}

#pragma mark - UITextFieldDelegate
//位数限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length == 1 && string.length == 0) {
        return YES;
    } else if ([textField isEqual:_phoneTF]) {
        return textField.text.length < SHPhoneLength;
    }  else if ([textField isEqual:_codeTF]) {
        return textField.text.length < SHCodeLength;
    }
    return YES;
}

//触发响应
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _phoneTF) {
        _phoneView.layer.borderColor = [SHColorFromHex(0x3d6b90) CGColor];
        _codeView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _psdView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    if (textField == _codeTF) {
        _codeView.layer.borderColor = [SHColorFromHex(0x3d6b90) CGColor];
        _phoneView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _psdView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    if (textField == _psdTF) {
        _psdView.layer.borderColor = [SHColorFromHex(0x3d6b90) CGColor];
        _phoneView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _codeView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self allTFResignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self allTFResignFirstResponder];
}

- (void)allTFResignFirstResponder {
    [_phoneTF resignFirstResponder];
    [_codeTF resignFirstResponder];
    [_psdTF resignFirstResponder];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
