using System;

namespace HHMS_Application.Forms
{
    public class LoginForm : BaseWebViewForm
    {
        public LoginForm() : base("Login.html", "Đăng nhập - Trung Tâm Ngoại Ngữ 68")
        {
            // Additional customization for login form
            this.Size = new System.Drawing.Size(900, 700);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = true;
        }
    }
}