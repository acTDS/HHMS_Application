using System;
using System.IO;
using System.Windows.Forms;
using Microsoft.Web.WebView2.WinForms;
using Microsoft.Web.WebView2.Core;
using HHMS_Application.Forms;

namespace HHMS_Application
{
    public class BaseWebViewForm : Form
    {
        protected WebView2 webView;
        private string htmlFileName;

        public BaseWebViewForm(string htmlFile, string title)
        {
            htmlFileName = htmlFile;
            InitializeComponent(title);
            InitializeWebView();
        }

        private void InitializeComponent(string title)
        {
            // Form properties
            this.Text = title;
            this.Size = new System.Drawing.Size(1200, 800);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.WindowState = FormWindowState.Normal;
            this.MinimumSize = new System.Drawing.Size(800, 600);

            // Create WebView2 control
            webView = new WebView2();
            webView.Dock = DockStyle.Fill;
            
            // Add WebView2 to form
            this.Controls.Add(webView);

            // Handle form resize events for auto-adjustment
            this.Resize += BaseWebViewForm_Resize;
            this.SizeChanged += BaseWebViewForm_SizeChanged;
        }

        private async void InitializeWebView()
        {
            try
            {
                // Initialize WebView2 core
                await webView.EnsureCoreWebView2Async();

                // Handle messages from web content (for t-code navigation)
                webView.CoreWebView2.WebMessageReceived += CoreWebView2_WebMessageReceived;

                // Get the path to the HTML file
                string htmlPath = Path.Combine(Application.StartupPath, "UI", htmlFileName);
                
                if (File.Exists(htmlPath))
                {
                    // Navigate to the HTML file
                    webView.CoreWebView2.Navigate(new Uri(htmlPath).ToString());
                }
                else
                {
                    // Show error if file not found
                    string errorHtml = $@"
                    <html>
                    <body style='font-family: Arial; padding: 20px; text-align: center;'>
                        <h2 style='color: red;'>File Not Found</h2>
                        <p>The HTML file '{htmlFileName}' was not found in the UI directory.</p>
                        <p>Expected path: {htmlPath}</p>
                    </body>
                    </html>";
                    webView.NavigateToString(errorHtml);
                }

                // Handle navigation events
                webView.CoreWebView2.NavigationCompleted += CoreWebView2_NavigationCompleted;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error initializing WebView2: {ex.Message}", "Error", 
                              MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void CoreWebView2_WebMessageReceived(object? sender, CoreWebView2WebMessageReceivedEventArgs e)
        {
            try
            {
                string message = e.TryGetWebMessageAsString();
                
                // Handle t-code navigation messages
                if (message.StartsWith("TCode:"))
                {
                    string tCode = message.Substring(6); // Remove "TCode:" prefix
                    OpenFormByTCode(tCode);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error handling web message: {ex.Message}", "Error", 
                              MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void OpenFormByTCode(string tCode)
        {
            try
            {
                Form? formToOpen = null;

                // Map t-codes to corresponding forms
                switch (tCode)
                {
                    case "STUDENT_VIEW":
                        formToOpen = new StudentListForm();
                        break;
                    case "CLASS_SCHEDULE":
                        formToOpen = new ClassListForm();
                        break;
                    case "PAYMENT_INFO":
                        formToOpen = new FinancialDashBoardForm();
                        break;
                    case "HR_MANAGEMENT":
                        formToOpen = new StaffListForm();
                        break;
                    case "COURSE_CATALOG":
                        formToOpen = new ClassDescriptionForm();
                        break;
                    case "TEACHER_ASSIGN":
                        formToOpen = new TeacherEditShiftLearnForm();
                        break;
                    case "EXAM_GRADING":
                        formToOpen = new ReportCreateForm();
                        break;
                    case "ATTENDANCE_TRACK":
                        formToOpen = new KeepingtimeForm();
                        break;
                    case "BRANCH_MANAGEMENT":
                        formToOpen = new BranchManagementForm();
                        break;
                    case "MAJOR_MANAGEMENT":
                        formToOpen = new MajorListForm();
                        break;
                    case "LOG_VIEW":
                        formToOpen = new LogForm();
                        break;
                    case "DOCUMENT_MANAGEMENT":
                        formToOpen = new DocumentListForm();
                        break;
                    default:
                        MessageBox.Show($"T-Code '{tCode}' không được hỗ trợ.", "T-Code không hợp lệ", 
                                      MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        return;
                }

                if (formToOpen != null)
                {
                    formToOpen.Show();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Lỗi khi mở form cho T-Code '{tCode}': {ex.Message}", "Lỗi", 
                              MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void CoreWebView2_NavigationCompleted(object? sender, CoreWebView2NavigationCompletedEventArgs e)
        {
            // Navigation completed - could add any post-load logic here
            if (!e.IsSuccess)
            {
                MessageBox.Show($"Navigation failed for {htmlFileName}", "Navigation Error", 
                              MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }

        private void BaseWebViewForm_Resize(object? sender, EventArgs e)
        {
            // Auto-adjust WebView2 size when form is resized
            if (webView != null)
            {
                webView.Size = this.ClientSize;
            }
        }

        private void BaseWebViewForm_SizeChanged(object? sender, EventArgs e)
        {
            // Additional size change handling for better responsiveness
            if (webView != null && webView.CoreWebView2 != null)
            {
                // Ensure WebView2 fills the client area
                webView.Bounds = this.ClientRectangle;
            }
        }

        protected override void OnFormClosed(FormClosedEventArgs e)
        {
            // Clean up WebView2 resources
            if (webView != null)
            {
                webView.Dispose();
            }
            base.OnFormClosed(e);
        }
    }
}