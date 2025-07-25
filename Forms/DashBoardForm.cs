using System;

namespace HHMS_Application.Forms
{
    public class DashBoardForm : BaseWebViewForm
    {
        public DashBoardForm() : base("DashBoard.html", "Bảng Điều Khiển - Trung Tâm Ngoại Ngữ 68")
        {
            // Additional customization for dashboard
            this.Size = new System.Drawing.Size(1400, 900);
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
        }
    }
}