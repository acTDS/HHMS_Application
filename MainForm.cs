using System;

namespace HHMS_Application
{
    public partial class MainForm : BaseWebViewForm
    {
        public MainForm() : base("DashBoard.html", "HHMS Application - Trung Tâm Ngoại Ngữ 68")
        {
            // Additional customization for main dashboard
            this.Size = new System.Drawing.Size(1400, 900);
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
        }
    }
}