using System;
using System.Drawing;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using HHMS_Application.Services;
using HHMS_Application.Models;

namespace HHMS_Application.Forms
{
    public class StudentListForm : BaseAPIForm
    {
        private readonly StudentService _studentService;

        // Controls
        private Panel searchPanel;
        private TextBox txtSearch;
        private ComboBox cbBranch;
        private Button btnSearch;
        private Button btnAdd;
        private Button btnEdit;
        private Button btnDelete;
        private Button btnRefresh;

        private DataGridView dgvStudents;
        private Panel buttonPanel;

        public StudentListForm() : base("Quản Lý Học Viên")
        {
            _studentService = new StudentService();
        }

        protected override void InitializeFormControls()
        {
            CreateSearchPanel();
            CreateButtonPanel();
            CreateDataGrid();
            SetupEventHandlers();
        }

        private void CreateSearchPanel()
        {
            searchPanel = new Panel
            {
                Dock = DockStyle.Top,
                Height = 80,
                BackColor = Color.FromArgb(248, 249, 250),
                Padding = new Padding(20, 15, 20, 15)
            };

            var searchLabel = new Label
            {
                Text = "Tìm kiếm:",
                Font = new Font("Segoe UI", 10, FontStyle.Bold),
                Location = new Point(0, 8),
                AutoSize = true
            };

            txtSearch = CreateTextBox("Nhập mã học viên, tên hoặc email...");
            txtSearch.Location = new Point(80, 5);
            txtSearch.Width = 300;

            var branchLabel = new Label
            {
                Text = "Chi nhánh:",
                Font = new Font("Segoe UI", 10, FontStyle.Bold),
                Location = new Point(400, 8),
                AutoSize = true
            };

            cbBranch = CreateComboBox();
            cbBranch.Location = new Point(480, 5);
            cbBranch.Width = 200;

            btnSearch = CreateButton("Tìm Kiếm", Color.FromArgb(0, 123, 255), Color.White, 100, 30);
            btnSearch.Location = new Point(700, 5);

            btnRefresh = CreateButton("Làm Mới", Color.FromArgb(108, 117, 125), Color.White, 100, 30);
            btnRefresh.Location = new Point(810, 5);

            searchPanel.Controls.AddRange(new Control[] {
                searchLabel, txtSearch, branchLabel, cbBranch, btnSearch, btnRefresh
            });

            mainPanel.Controls.Add(searchPanel);
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

            btnAdd = CreateButton("Thêm Mới", Color.FromArgb(40, 167, 69), Color.White, 120, 35);
            btnAdd.Location = new Point(0, 0);

            btnEdit = CreateButton("Chỉnh Sửa", Color.FromArgb(255, 193, 7), Color.Black, 120, 35);
            btnEdit.Location = new Point(130, 0);
            btnEdit.Enabled = false;

            btnDelete = CreateButton("Xóa", Color.FromArgb(220, 53, 69), Color.White, 120, 35);
            btnDelete.Location = new Point(260, 0);
            btnDelete.Enabled = false;

            buttonPanel.Controls.AddRange(new Control[] { btnAdd, btnEdit, btnDelete });
            mainPanel.Controls.Add(buttonPanel);
        }

        private void CreateDataGrid()
        {
            dgvStudents = CreateDataGridView();
            dgvStudents.Dock = DockStyle.Fill;

            // Add columns
            dgvStudents.Columns.Add("StudentID", "ID");
            dgvStudents.Columns.Add("StudentCode", "Mã Học Viên");
            dgvStudents.Columns.Add("FullName", "Họ Tên");
            dgvStudents.Columns.Add("Gender", "Giới Tính");
            dgvStudents.Columns.Add("BirthDate", "Ngày Sinh");
            dgvStudents.Columns.Add("Phone", "Điện Thoại");
            dgvStudents.Columns.Add("Email", "Email");
            dgvStudents.Columns.Add("EnrollmentDate", "Ngày Đăng Ký");
            dgvStudents.Columns.Add("BranchName", "Chi Nhánh");

            // Hide ID column
            dgvStudents.Columns["StudentID"].Visible = false;

            // Set column widths
            dgvStudents.Columns["StudentCode"].Width = 120;
            dgvStudents.Columns["FullName"].Width = 200;
            dgvStudents.Columns["Gender"].Width = 80;
            dgvStudents.Columns["BirthDate"].Width = 100;
            dgvStudents.Columns["Phone"].Width = 120;
            dgvStudents.Columns["Email"].Width = 200;
            dgvStudents.Columns["EnrollmentDate"].Width = 120;
            dgvStudents.Columns["BranchName"].Width = 150;

            mainPanel.Controls.Add(dgvStudents);
        }

        private void SetupEventHandlers()
        {
            btnSearch.Click += async (s, e) => await SearchStudents();
            btnRefresh.Click += async (s, e) => await LoadDataAsync();
            btnAdd.Click += (s, e) => AddStudent();
            btnEdit.Click += (s, e) => EditStudent();
            btnDelete.Click += async (s, e) => await DeleteStudent();

            dgvStudents.SelectionChanged += (s, e) =>
            {
                bool hasSelection = dgvStudents.SelectedRows.Count > 0;
                btnEdit.Enabled = hasSelection;
                btnDelete.Enabled = hasSelection;
            };

            dgvStudents.CellDoubleClick += (s, e) =>
            {
                if (e.RowIndex >= 0)
                {
                    EditStudent();
                }
            };

            txtSearch.KeyPress += async (s, e) =>
            {
                if (e.KeyChar == (char)Keys.Enter)
                {
                    await SearchStudents();
                }
            };
        }

        protected override async Task LoadDataAsync()
        {
            await ExecuteWithLoadingAsync(async () =>
            {
                // Load branches for filter
                await LoadBranches();

                // Load students
                var response = await _studentService.GetAllStudentsAsync();
                if (response.Success)
                {
                    UpdateStudentGrid(response.Data);
                    HideLoading($"Đã tải {response.Data.Count} học viên");
                }
                else
                {
                    ShowError(response.Message);
                }
            });
        }

        private async Task LoadBranches()
        {
            // TODO: Load branches from BranchService
            cbBranch.Items.Clear();
            cbBranch.Items.Add("Tất cả chi nhánh");
            cbBranch.Items.Add("Chi nhánh Hà Nội");
            cbBranch.Items.Add("Chi nhánh TP.HCM");
            cbBranch.Items.Add("Chi nhánh Đà Nẵng");
            cbBranch.SelectedIndex = 0;
        }

        private async Task SearchStudents()
        {
            var searchTerm = txtSearch.Text;
            if (searchTerm == "Nhập mã học viên, tên hoặc email...")
                searchTerm = "";

            await ExecuteWithLoadingAsync(async () =>
            {
                var response = await _studentService.GetAllStudentsAsync(searchTerm);
                if (response.Success)
                {
                    UpdateStudentGrid(response.Data);
                    HideLoading($"Tìm thấy {response.Data.Count} học viên");
                }
                else
                {
                    ShowError(response.Message);
                }
            });
        }

        private void UpdateStudentGrid(System.Collections.Generic.List<Student> students)
        {
            dgvStudents.Rows.Clear();

            foreach (var student in students)
            {
                var rowIndex = dgvStudents.Rows.Add(
                    student.StudentID,
                    student.StudentCode,
                    student.FullName,
                    student.Gender ?? "",
                    student.BirthDate?.ToString("dd/MM/yyyy") ?? "",
                    student.Phone ?? "",
                    student.Email ?? "",
                    student.EnrollmentDate.ToString("dd/MM/yyyy"),
                    "" // BranchName - will be populated when we have branch data
                );

                // Color coding for different statuses
                if (student.StatusID != 1)
                {
                    dgvStudents.Rows[rowIndex].DefaultCellStyle.BackColor = Color.FromArgb(248, 249, 250);
                    dgvStudents.Rows[rowIndex].DefaultCellStyle.ForeColor = Color.Gray;
                }
            }
        }

        private void AddStudent()
        {
            var addForm = new StudentEditForm();
            if (addForm.ShowDialog() == DialogResult.OK)
            {
                _ = LoadDataAsync(); // Refresh grid
            }
        }

        private void EditStudent()
        {
            if (dgvStudents.SelectedRows.Count > 0)
            {
                var studentId = (int)dgvStudents.SelectedRows[0].Cells["StudentID"].Value;
                var editForm = new StudentEditForm(studentId);
                if (editForm.ShowDialog() == DialogResult.OK)
                {
                    _ = LoadDataAsync(); // Refresh grid
                }
            }
        }

        private async Task DeleteStudent()
        {
            if (dgvStudents.SelectedRows.Count > 0)
            {
                var studentName = dgvStudents.SelectedRows[0].Cells["FullName"].Value.ToString();
                var result = MessageBox.Show(
                    $"Bạn có chắc chắn muốn xóa học viên '{studentName}'?",
                    "Xác nhận xóa",
                    MessageBoxButtons.YesNo,
                    MessageBoxIcon.Question);

                if (result == DialogResult.Yes)
                {
                    var studentId = (int)dgvStudents.SelectedRows[0].Cells["StudentID"].Value;
                    
                    await ExecuteWithLoadingAsync(async () =>
                    {
                        var response = await _studentService.DeleteStudentAsync(studentId);
                        if (response.Success)
                        {
                            ShowSuccess("Xóa học viên thành công");
                            await LoadDataAsync();
                        }
                        else
                        {
                            ShowError(response.Message);
                        }
                    });
                }
            }
        }
    }

    // Placeholder for Student Edit Form
    public class StudentEditForm : Form
    {
        public StudentEditForm(int? studentId = null)
        {
            Text = studentId.HasValue ? "Chỉnh Sửa Học Viên" : "Thêm Học Viên Mới";
            Size = new Size(600, 500);
            StartPosition = FormStartPosition.CenterParent;

            // TODO: Implement student edit form with API integration
            var label = new Label
            {
                Text = "Form chỉnh sửa học viên sẽ được triển khai với API integration",
                Location = new Point(50, 50),
                AutoSize = true
            };

            var btnOK = new Button
            {
                Text = "OK",
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
}