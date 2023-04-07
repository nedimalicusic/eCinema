using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application
{
    public class EmployeesService : BaseService<Employee, EmployeeDto, EmployeeUpsertDto, BaseSearchObject, IEmployeesRepository>, IEmployeesService
    {
        public EmployeesService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<EmployeeUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
