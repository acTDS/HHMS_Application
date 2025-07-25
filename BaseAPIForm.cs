using System;
using System.Drawing;
using System.Windows.Forms;
using System.Threading.Tasks;

namespace HHMS_Application
{
    public abstract class BaseAPIForm : Form
    {
        protected Panel headerPanel;
        protected Label titleLabel;
        protected Panel mainPanel;
        protected Panel statusPanel;
        protected Label statusLabel;
        protected ProgressBar loadingProgressBar;

        public BaseAPIForm(string title)
        {
            InitializeBaseForm(title);
            SetupLayout();
        }

        private void InitializeBaseForm(string title)
        {
            // Form properties
            this.Text = title;
            this.Size = new Size(1200, 800);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.WindowState = FormWindowState.Normal;
            this.MinimumSize = new Size(800, 600);
            this.BackColor = Color.FromArgb(240, 244, 248);
        }

        private void SetupLayout()
        {
            // Header Panel
            headerPanel = new Panel
            {
                Dock = DockStyle.Top,
                Height = 60,
                BackColor = Color.FromArgb(0, 123, 191),
                Padding = new Padding(20, 10, 20, 10)
            };

            titleLabel = new Label
            {
                Text = this.Text,
                Font = new Font("Segoe UI", 16, FontStyle.Bold),
                ForeColor = Color.White,
                Dock = DockStyle.Fill,
                TextAlign = ContentAlignment.MiddleLeft
            };

            headerPanel.Controls.Add(titleLabel);

            // Status Panel
            statusPanel = new Panel
            {
                Dock = DockStyle.Bottom,
                Height = 30,
                BackColor = Color.FromArgb(248, 249, 250),
                Padding = new Padding(10, 5, 10, 5)
            };

            statusLabel = new Label
            {
                Text = "Sẵn sàng",
                Font = new Font("Segoe UI", 9),
                ForeColor = Color.FromArgb(108, 117, 125),
                Dock = DockStyle.Left,
                AutoSize = true,
                TextAlign = ContentAlignment.MiddleLeft
            };

            loadingProgressBar = new ProgressBar
            {
                Style = ProgressBarStyle.Marquee,
                Dock = DockStyle.Right,
                Width = 200,
                Visible = false
            };

            statusPanel.Controls.Add(statusLabel);
            statusPanel.Controls.Add(loadingProgressBar);

            // Main Panel for content
            mainPanel = new Panel
            {
                Dock = DockStyle.Fill,
                Padding = new Padding(20),
                BackColor = Color.White
            };

            // Add panels to form
            this.Controls.Add(mainPanel);
            this.Controls.Add(headerPanel);
            this.Controls.Add(statusPanel);
        }

        protected void ShowLoading(string message = "Đang tải dữ liệu...")
        {
            statusLabel.Text = message;
            loadingProgressBar.Visible = true;
            this.Cursor = Cursors.WaitCursor;
            Application.DoEvents();
        }

        protected void HideLoading(string message = "Sẵn sàng")
        {
            statusLabel.Text = message;
            loadingProgressBar.Visible = false;
            this.Cursor = Cursors.Default;
        }

        protected void ShowError(string message)
        {
            MessageBox.Show(message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            statusLabel.Text = "Có lỗi xảy ra";
        }

        protected void ShowSuccess(string message)
        {
            MessageBox.Show(message, "Thành công", MessageBoxButtons.OK, MessageBoxIcon.Information);
            statusLabel.Text = "Thành công";
        }

        protected void ShowWarning(string message)
        {
            MessageBox.Show(message, "Cảnh báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            statusLabel.Text = "Cảnh báo";
        }

        protected async Task<bool> ExecuteWithLoadingAsync(Func<Task> action, string loadingMessage = "Đang xử lý...")
        {
            try
            {
                ShowLoading(loadingMessage);
                await action();
                HideLoading("Hoàn thành");
                return true;
            }
            catch (Exception ex)
            {
                HideLoading();
                ShowError($"Lỗi: {ex.Message}");
                return false;
            }
        }

        protected async Task<T> ExecuteWithLoadingAsync<T>(Func<Task<T>> action, string loadingMessage = "Đang xử lý...")
        {
            try
            {
                ShowLoading(loadingMessage);
                var result = await action();
                HideLoading("Hoàn thành");
                return result;
            }
            catch (Exception ex)
            {
                HideLoading();
                ShowError($"Lỗi: {ex.Message}");
                return default(T);
            }
        }

        protected Button CreateButton(string text, Color backColor, Color foreColor, int width = 100, int height = 35)
        {
            return new Button
            {
                Text = text,
                BackColor = backColor,
                ForeColor = foreColor,
                Size = new Size(width, height),
                FlatStyle = FlatStyle.Flat,
                Font = new Font("Segoe UI", 9, FontStyle.Bold),
                Cursor = Cursors.Hand
            };
        }

        protected DataGridView CreateDataGridView()
        {
            var dgv = new DataGridView
            {
                Dock = DockStyle.Fill,
                BackgroundColor = Color.White,
                BorderStyle = BorderStyle.None,
                CellBorderStyle = DataGridViewCellBorderStyle.SingleHorizontal,
                ColumnHeadersBorderStyle = DataGridViewHeaderBorderStyle.None,
                EnableHeadersVisualStyles = false,
                SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                MultiSelect = false,
                ReadOnly = true,
                AllowUserToAddRows = false,
                AllowUserToDeleteRows = false,
                AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
            };

            // Style headers
            dgv.ColumnHeadersDefaultCellStyle.BackColor = Color.FromArgb(52, 58, 64);
            dgv.ColumnHeadersDefaultCellStyle.ForeColor = Color.White;
            dgv.ColumnHeadersDefaultCellStyle.Font = new Font("Segoe UI", 10, FontStyle.Bold);
            dgv.ColumnHeadersDefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            dgv.ColumnHeadersHeight = 40;

            // Style rows
            dgv.DefaultCellStyle.Font = new Font("Segoe UI", 9);
            dgv.DefaultCellStyle.BackColor = Color.White;
            dgv.DefaultCellStyle.ForeColor = Color.FromArgb(33, 37, 41);
            dgv.DefaultCellStyle.SelectionBackColor = Color.FromArgb(0, 123, 255);
            dgv.DefaultCellStyle.SelectionForeColor = Color.White;
            dgv.RowTemplate.Height = 35;

            // Alternating row colors
            dgv.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(248, 249, 250);

            return dgv;
        }

        protected TextBox CreateTextBox(string placeholder = "", bool multiline = false)
        {
            var textBox = new TextBox
            {
                Font = new Font("Segoe UI", 10),
                BorderStyle = BorderStyle.FixedSingle,
                Multiline = multiline
            };

            if (multiline)
            {
                textBox.Height = 80;
                textBox.ScrollBars = ScrollBars.Vertical;
            }
            else
            {
                textBox.Height = 30;
            }

            // Add placeholder functionality
            if (!string.IsNullOrEmpty(placeholder))
            {
                textBox.Text = placeholder;
                textBox.ForeColor = Color.Gray;
                
                textBox.Enter += (s, e) => {
                    if (textBox.Text == placeholder)
                    {
                        textBox.Text = "";
                        textBox.ForeColor = Color.Black;
                    }
                };
                
                textBox.Leave += (s, e) => {
                    if (string.IsNullOrWhiteSpace(textBox.Text))
                    {
                        textBox.Text = placeholder;
                        textBox.ForeColor = Color.Gray;
                    }
                };
            }

            return textBox;
        }

        protected ComboBox CreateComboBox()
        {
            return new ComboBox
            {
                Font = new Font("Segoe UI", 10),
                DropDownStyle = ComboBoxStyle.DropDownList,
                Height = 30
            };
        }

        protected GroupBox CreateGroupBox(string title)
        {
            return new GroupBox
            {
                Text = title,
                Font = new Font("Segoe UI", 10, FontStyle.Bold),
                ForeColor = Color.FromArgb(52, 58, 64),
                Padding = new Padding(10)
            };
        }

        // Abstract method for child forms to implement their specific data loading
        protected abstract Task LoadDataAsync();

        // Virtual method for child forms to override for initialization
        protected virtual void InitializeFormControls()
        {
            // Override in child forms
        }

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            InitializeFormControls();
            _ = LoadDataAsync(); // Fire and forget for initial load
        }
    }
}