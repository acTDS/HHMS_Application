using System;
using System.Drawing;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using HHMS_Application.Services;
using HHMS_Application.Models;

namespace HHMS_Application.Forms
{
    public class RequestSummaryForm : BaseAPIForm
    {
        private readonly RequestService _requestService;

        // Controls
        private Panel filterPanel;
        private ComboBox cbRequestType;
        private ComboBox cbStatus;
        private TextBox txtRequester;
        private TextBox txtApprover;
        private DateTimePicker dtpFrom;
        private DateTimePicker dtpTo;
        private Button btnFilter;
        private Button btnRefresh;
        private Button btnExport;

        private Panel metricsPanel;
        private Label lblTotalRequests;
        private Label lblPendingAppraisal;
        private Label lblPendingApproval;
        private Label lblApproved;
        private Label lblRejected;
        private Label lblOverdue;

        private DataGridView dgvRequests;
        private Panel buttonPanel;
        private Button btnAppraise;
        private Button btnApprove;
        private Button btnReject;
        private Button btnViewDetails;

        public RequestSummaryForm() : base("Tóm Tắt Yêu Cầu - Request Summary")
        {
            _requestService = new RequestService();
        }

        protected override void InitializeFormControls()
        {
            CreateFilterPanel();
            CreateMetricsPanel();
            CreateDataGrid();
            CreateButtonPanel();
            SetupEventHandlers();
        }

        private void CreateFilterPanel()
        {
            filterPanel = new Panel
            {
                Dock = DockStyle.Top,
                Height = 120,
                BackColor = Color.FromArgb(248, 249, 250),
                Padding = new Padding(20, 10, 20, 10)
            };

            // First row
            var lblRequestType = new Label
            {
                Text = "Loại yêu cầu:",
                Font = new Font("Segoe UI", 9, FontStyle.Bold),
                Location = new Point(0, 8),
                AutoSize = true
            };

            cbRequestType = CreateComboBox();
            cbRequestType.Location = new Point(100, 5);
            cbRequestType.Width = 150;

            var lblStatus = new Label
            {
                Text = "Trạng thái:",
                Font = new Font("Segoe UI", 9, FontStyle.Bold),
                Location = new Point(270, 8),
                AutoSize = true
            };

            cbStatus = CreateComboBox();
            cbStatus.Location = new Point(350, 5);
            cbStatus.Width = 150;

            var lblRequester = new Label
            {
                Text = "Người yêu cầu:",
                Font = new Font("Segoe UI", 9, FontStyle.Bold),
                Location = new Point(520, 8),
                AutoSize = true
            };

            txtRequester = CreateTextBox("Tên người yêu cầu...");
            txtRequester.Location = new Point(620, 5);
            txtRequester.Width = 150;

            // Second row
            var lblApprover = new Label
            {
                Text = "Người duyệt:",
                Font = new Font("Segoe UI", 9, FontStyle.Bold),
                Location = new Point(0, 48),
                AutoSize = true
            };

            txtApprover = CreateTextBox("Tên người duyệt...");
            txtApprover.Location = new Point(100, 45);
            txtApprover.Width = 150;

            var lblDateRange = new Label
            {
                Text = "Từ ngày:",
                Font = new Font("Segoe UI", 9, FontStyle.Bold),
                Location = new Point(270, 48),
                AutoSize = true
            };

            dtpFrom = new DateTimePicker
            {
                Location = new Point(340, 45),
                Width = 120,
                Format = DateTimePickerFormat.Short,
                Value = DateTime.Now.AddDays(-30)
            };

            var lblToDate = new Label
            {
                Text = "Đến:",
                Font = new Font("Segoe UI", 9, FontStyle.Bold),
                Location = new Point(480, 48),
                AutoSize = true
            };

            dtpTo = new DateTimePicker
            {
                Location = new Point(520, 45),
                Width = 120,
                Format = DateTimePickerFormat.Short,
                Value = DateTime.Now
            };

            btnFilter = CreateButton("Lọc", Color.FromArgb(0, 123, 255), Color.White, 80, 30);
            btnFilter.Location = new Point(660, 45);

            btnRefresh = CreateButton("Làm mới", Color.FromArgb(108, 117, 125), Color.White, 80, 30);
            btnRefresh.Location = new Point(750, 45);

            btnExport = CreateButton("Xuất Excel", Color.FromArgb(40, 167, 69), Color.White, 100, 30);
            btnExport.Location = new Point(840, 45);

            filterPanel.Controls.AddRange(new Control[] {
                lblRequestType, cbRequestType, lblStatus, cbStatus, lblRequester, txtRequester,
                lblApprover, txtApprover, lblDateRange, dtpFrom, lblToDate, dtpTo,
                btnFilter, btnRefresh, btnExport
            });

            mainPanel.Controls.Add(filterPanel);
        }

        private void CreateMetricsPanel()
        {
            metricsPanel = new Panel
            {
                Dock = DockStyle.Top,
                Height = 80,
                BackColor = Color.White,
                Padding = new Padding(20, 10, 20, 10)
            };

            var metricsGroupBox = CreateGroupBox("Thống Kê Tổng Quan");
            metricsGroupBox.Dock = DockStyle.Fill;

            var metricsFlow = new FlowLayoutPanel
            {
                Dock = DockStyle.Fill,
                FlowDirection = FlowDirection.LeftToRight,
                WrapContents = false,
                AutoScroll = true
            };

            lblTotalRequests = CreateMetricLabel("Tổng số: 0", Color.FromArgb(52, 144, 220));
            lblPendingAppraisal = CreateMetricLabel("Chờ thẩm định: 0", Color.FromArgb(255, 193, 7));
            lblPendingApproval = CreateMetricLabel("Chờ phê duyệt: 0", Color.FromArgb(255, 193, 7));
            lblApproved = CreateMetricLabel("Đã phê duyệt: 0", Color.FromArgb(40, 167, 69));
            lblRejected = CreateMetricLabel("Đã từ chối: 0", Color.FromArgb(220, 53, 69));
            lblOverdue = CreateMetricLabel("Quá hạn: 0", Color.FromArgb(220, 53, 69));

            metricsFlow.Controls.AddRange(new Control[] {
                lblTotalRequests, lblPendingAppraisal, lblPendingApproval, 
                lblApproved, lblRejected, lblOverdue
            });

            metricsGroupBox.Controls.Add(metricsFlow);
            metricsPanel.Controls.Add(metricsGroupBox);
            mainPanel.Controls.Add(metricsPanel);
        }

        private Label CreateMetricLabel(string text, Color color)
        {
            return new Label
            {
                Text = text,
                Font = new Font("Segoe UI", 10, FontStyle.Bold),
                ForeColor = color,
                AutoSize = true,
                Margin = new Padding(0, 10, 20, 10),
                BorderStyle = BorderStyle.FixedSingle,
                Padding = new Padding(10, 5, 10, 5),
                BackColor = Color.FromArgb(248, 249, 250)
            };
        }

        private void CreateDataGrid()
        {
            dgvRequests = CreateDataGridView();
            dgvRequests.Dock = DockStyle.Fill;

            // Add columns
            dgvRequests.Columns.Add("RequestID", "ID");
            dgvRequests.Columns.Add("RequestCode", "Mã YC");
            dgvRequests.Columns.Add("RequestTypeName", "Loại YC");
            dgvRequests.Columns.Add("Title", "Tiêu Đề");
            dgvRequests.Columns.Add("RequesterName", "Người YC");
            dgvRequests.Columns.Add("AppraiserName", "Người Thẩm Định");
            dgvRequests.Columns.Add("ApproverName", "Người Phê Duyệt");
            dgvRequests.Columns.Add("StatusDisplayName", "Trạng Thái");
            dgvRequests.Columns.Add("Priority", "Ưu Tiên");
            dgvRequests.Columns.Add("SubmissionDate", "Ngày Gửi");
            dgvRequests.Columns.Add("ProcessingDays", "Số Ngày");
            dgvRequests.Columns.Add("ProgressStatus", "Tiến Độ");
            dgvRequests.Columns.Add("EstimatedCost", "Chi Phí DT");
            dgvRequests.Columns.Add("LatestAppraisalScore", "Điểm TĐ");

            // Hide ID column
            dgvRequests.Columns["RequestID"].Visible = false;

            // Set column widths
            dgvRequests.Columns["RequestCode"].Width = 100;
            dgvRequests.Columns["RequestTypeName"].Width = 120;
            dgvRequests.Columns["Title"].Width = 200;
            dgvRequests.Columns["RequesterName"].Width = 150;
            dgvRequests.Columns["AppraiserName"].Width = 120;
            dgvRequests.Columns["ApproverName"].Width = 120;
            dgvRequests.Columns["StatusDisplayName"].Width = 130;
            dgvRequests.Columns["Priority"].Width = 80;
            dgvRequests.Columns["SubmissionDate"].Width = 100;
            dgvRequests.Columns["ProcessingDays"].Width = 80;
            dgvRequests.Columns["ProgressStatus"].Width = 100;
            dgvRequests.Columns["EstimatedCost"].Width = 100;
            dgvRequests.Columns["LatestAppraisalScore"].Width = 80;

            // Format columns
            dgvRequests.Columns["EstimatedCost"].DefaultCellStyle.Format = "C0";
            dgvRequests.Columns["EstimatedCost"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            dgvRequests.Columns["ProcessingDays"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            dgvRequests.Columns["LatestAppraisalScore"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;

            mainPanel.Controls.Add(dgvRequests);
        }

        private void CreateButtonPanel()
        {
            buttonPanel = new Panel
            {
                Dock = DockStyle.Bottom,
                Height = 60,
                BackColor = Color.FromArgb(248, 249, 250),
                Padding = new Padding(20, 15, 20, 15)
            };

            btnAppraise = CreateButton("Thẩm Định", Color.FromArgb(0, 123, 255), Color.White, 120, 35);
            btnAppraise.Location = new Point(0, 0);
            btnAppraise.Enabled = false;

            btnApprove = CreateButton("Phê Duyệt", Color.FromArgb(40, 167, 69), Color.White, 120, 35);
            btnApprove.Location = new Point(130, 0);
            btnApprove.Enabled = false;

            btnReject = CreateButton("Từ Chối", Color.FromArgb(220, 53, 69), Color.White, 120, 35);
            btnReject.Location = new Point(260, 0);
            btnReject.Enabled = false;

            btnViewDetails = CreateButton("Xem Chi Tiết", Color.FromArgb(102, 16, 242), Color.White, 120, 35);
            btnViewDetails.Location = new Point(390, 0);
            btnViewDetails.Enabled = false;

            buttonPanel.Controls.AddRange(new Control[] { 
                btnAppraise, btnApprove, btnReject, btnViewDetails 
            });

            mainPanel.Controls.Add(buttonPanel);
        }

        private void SetupEventHandlers()
        {
            btnFilter.Click += async (s, e) => await FilterRequests();
            btnRefresh.Click += async (s, e) => await LoadDataAsync();
            btnExport.Click += (s, e) => ExportToExcel();
            btnAppraise.Click += (s, e) => AppraiseRequest();
            btnApprove.Click += (s, e) => ApproveRequest();
            btnReject.Click += (s, e) => RejectRequest();
            btnViewDetails.Click += (s, e) => ViewRequestDetails();

            dgvRequests.SelectionChanged += (s, e) =>
            {
                bool hasSelection = dgvRequests.SelectedRows.Count > 0;
                btnViewDetails.Enabled = hasSelection;

                if (hasSelection)
                {
                    var status = dgvRequests.SelectedRows[0].Cells["StatusDisplayName"].Value.ToString();
                    btnAppraise.Enabled = status == "Đang chờ thẩm định";
                    btnApprove.Enabled = status == "Đã thẩm định" || status == "Đang chờ phê duyệt";
                    btnReject.Enabled = status != "Đã phê duyệt" && status != "Đã từ chối";
                }
                else
                {
                    btnAppraise.Enabled = false;
                    btnApprove.Enabled = false;
                    btnReject.Enabled = false;
                }
            };

            dgvRequests.CellDoubleClick += (s, e) =>
            {
                if (e.RowIndex >= 0)
                {
                    ViewRequestDetails();
                }
            };
        }

        protected override async Task LoadDataAsync()
        {
            await ExecuteWithLoadingAsync(async () =>
            {
                // Load filter data
                await LoadFilterData();

                // Load requests
                var response = await _requestService.GetRequestSummaryAsync(1); // User ID = 1
                if (response.Success)
                {
                    UpdateRequestGrid(response.Data);
                }
                else
                {
                    ShowError(response.Message);
                }

                // Load metrics
                var metricsResponse = await _requestService.GetRequestMetricsAsync();
                if (metricsResponse.Success)
                {
                    UpdateMetrics(metricsResponse.Data);
                }
            });
        }

        private async Task LoadFilterData()
        {
            // Load request types
            cbRequestType.Items.Clear();
            cbRequestType.Items.Add("Tất cả loại");
            cbRequestType.Items.Add("Yêu cầu học viên");
            cbRequestType.Items.Add("Yêu cầu tài chính");
            cbRequestType.Items.Add("Yêu cầu tài liệu");
            cbRequestType.Items.Add("Yêu cầu nhân sự");
            cbRequestType.Items.Add("Yêu cầu khóa học");
            cbRequestType.Items.Add("Xin nghỉ phép");
            cbRequestType.SelectedIndex = 0;

            // Load status
            cbStatus.Items.Clear();
            cbStatus.Items.Add("Tất cả trạng thái");
            cbStatus.Items.Add("Đang chờ thẩm định");
            cbStatus.Items.Add("Đã thẩm định");
            cbStatus.Items.Add("Đang chờ phê duyệt");
            cbStatus.Items.Add("Đã phê duyệt");
            cbStatus.Items.Add("Đã từ chối");
            cbStatus.SelectedIndex = 0;
        }

        private async Task FilterRequests()
        {
            var statusFilter = cbStatus.SelectedItem.ToString();
            if (statusFilter == "Tất cả trạng thái") statusFilter = null;

            var requesterFilter = txtRequester.Text;
            if (requesterFilter == "Tên người yêu cầu...") requesterFilter = null;

            var approverFilter = txtApprover.Text;
            if (approverFilter == "Tên người duyệt...") approverFilter = null;

            await ExecuteWithLoadingAsync(async () =>
            {
                var response = await _requestService.GetRequestSummaryAsync(
                    userId: 1,
                    statusFilter: statusFilter,
                    requesterFilter: requesterFilter,
                    approverFilter: approverFilter,
                    dateFrom: dtpFrom.Value.Date,
                    dateTo: dtpTo.Value.Date
                );

                if (response.Success)
                {
                    UpdateRequestGrid(response.Data);
                    HideLoading($"Tìm thấy {response.Data.Count} yêu cầu");
                }
                else
                {
                    ShowError(response.Message);
                }
            });
        }

        private void UpdateRequestGrid(System.Collections.Generic.List<RequestSummary> requests)
        {
            dgvRequests.Rows.Clear();

            foreach (var request in requests)
            {
                var rowIndex = dgvRequests.Rows.Add(
                    request.RequestID,
                    request.RequestCode,
                    request.RequestTypeName,
                    request.Title,
                    request.RequesterName,
                    request.AppraiserName ?? "",
                    request.ApproverName ?? "",
                    request.StatusDisplayName,
                    request.Priority,
                    request.SubmissionDate.ToString("dd/MM/yyyy"),
                    request.ProcessingDays,
                    request.ProgressStatus,
                    request.EstimatedCost,
                    request.LatestAppraisalScore
                );

                // Color coding based on status
                var row = dgvRequests.Rows[rowIndex];
                switch (request.StatusDisplayName)
                {
                    case "Đang chờ thẩm định":
                        row.DefaultCellStyle.BackColor = Color.FromArgb(255, 248, 220);
                        break;
                    case "Đã thẩm định":
                        row.DefaultCellStyle.BackColor = Color.FromArgb(220, 248, 255);
                        break;
                    case "Đang chờ phê duyệt":
                        row.DefaultCellStyle.BackColor = Color.FromArgb(255, 240, 220);
                        break;
                    case "Đã phê duyệt":
                        row.DefaultCellStyle.BackColor = Color.FromArgb(220, 255, 220);
                        break;
                    case "Đã từ chối":
                        row.DefaultCellStyle.BackColor = Color.FromArgb(255, 220, 220);
                        break;
                }

                // Highlight overdue requests
                if (request.ProgressStatus == "Overdue")
                {
                    row.DefaultCellStyle.ForeColor = Color.Red;
                    row.DefaultCellStyle.Font = new Font(row.DefaultCellStyle.Font, FontStyle.Bold);
                }
            }
        }

        private void UpdateMetrics(dynamic metrics)
        {
            lblTotalRequests.Text = $"Tổng số: {metrics.TotalRequests}";
            lblPendingAppraisal.Text = $"Chờ thẩm định: {metrics.PendingAppraisal}";
            lblPendingApproval.Text = $"Chờ phê duyệt: {metrics.PendingApproval}";
            lblApproved.Text = $"Đã phê duyệt: {metrics.Approved}";
            lblRejected.Text = $"Đã từ chối: {metrics.Rejected}";
            lblOverdue.Text = $"Quá hạn: {metrics.OverdueRequests}";
        }

        private void AppraiseRequest()
        {
            if (dgvRequests.SelectedRows.Count > 0)
            {
                var requestId = (int)dgvRequests.SelectedRows[0].Cells["RequestID"].Value;
                var requestCode = dgvRequests.SelectedRows[0].Cells["RequestCode"].Value.ToString();
                
                var appraiseForm = new RequestAppraiseForm(requestId, requestCode);
                if (appraiseForm.ShowDialog() == DialogResult.OK)
                {
                    _ = LoadDataAsync(); // Refresh
                }
            }
        }

        private void ApproveRequest()
        {
            // TODO: Implement approve request functionality
            ShowWarning("Chức năng phê duyệt yêu cầu sẽ được triển khai");
        }

        private void RejectRequest()
        {
            // TODO: Implement reject request functionality
            ShowWarning("Chức năng từ chối yêu cầu sẽ được triển khai");
        }

        private void ViewRequestDetails()
        {
            if (dgvRequests.SelectedRows.Count > 0)
            {
                var requestId = (int)dgvRequests.SelectedRows[0].Cells["RequestID"].Value;
                var detailsForm = new RequestDetailsForm(requestId);
                detailsForm.Show();
            }
        }

        private void ExportToExcel()
        {
            // TODO: Implement Excel export functionality
            ShowWarning("Chức năng xuất Excel sẽ được triển khai");
        }
    }

    // Placeholder forms
    public class RequestAppraiseForm : Form
    {
        public RequestAppraiseForm(int requestId, string requestCode)
        {
            Text = $"Thẩm Định Yêu Cầu - {requestCode}";
            Size = new Size(600, 500);
            StartPosition = FormStartPosition.CenterParent;
            
            var label = new Label
            {
                Text = $"Form thẩm định cho yêu cầu {requestCode} (ID: {requestId})",
                Location = new Point(50, 50),
                AutoSize = true
            };

            var btnOK = new Button
            {
                Text = "Thẩm Định",
                DialogResult = DialogResult.OK,
                Location = new Point(200, 400),
                Size = new Size(100, 35)
            };

            var btnCancel = new Button
            {
                Text = "Hủy",
                DialogResult = DialogResult.Cancel,
                Location = new Point(320, 400),
                Size = new Size(100, 35)
            };

            Controls.AddRange(new Control[] { label, btnOK, btnCancel });
        }
    }

    public class RequestDetailsForm : Form
    {
        public RequestDetailsForm(int requestId)
        {
            Text = $"Chi Tiết Yêu Cầu - ID: {requestId}";
            Size = new Size(800, 600);
            StartPosition = FormStartPosition.CenterParent;
            
            var label = new Label
            {
                Text = $"Form xem chi tiết yêu cầu ID: {requestId}",
                Location = new Point(50, 50),
                AutoSize = true
            };

            Controls.Add(label);
        }
    }
}