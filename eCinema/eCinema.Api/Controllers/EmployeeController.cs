using eCinema.Application.Interfaces;
using eCinema.Infrastructure.Interfaces;
using eCinema.Core;

namespace eCinema.Api.Controllers
{
    public class EmployeeController : BaseCrudController<EmployeeDto, EmployeeUpsertDto, BaseSearchObject, IEmployeesService>
    {
        public EmployeeController(IEmployeesService service, ILogger<EmployeeController> logger) : base(service, logger)
        {
        }
    }
}
