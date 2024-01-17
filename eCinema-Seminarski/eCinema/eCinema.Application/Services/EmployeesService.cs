using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Application
{
    public class EmployeesService : BaseService<Employee, EmployeeDto, EmployeeUpsertDto, EmployeeSearchObject, IEmployeesRepository>, IEmployeesService
    {
        public EmployeesService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<EmployeeUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }

        public override async Task<EmployeeDto> AddAsync(EmployeeUpsertDto dto, CancellationToken cancellationToken = default)
        {
            await ValidateAsync(dto, cancellationToken);

            var entity = Mapper.Map<Employee>(dto);

            await CurrentRepository.AddAsync(entity, cancellationToken);
            await UnitOfWork.SaveChangesAsync(cancellationToken);
            return Mapper.Map<EmployeeDto>(entity);
        }

        public override async Task<EmployeeDto> UpdateAsync(EmployeeUpsertDto dto, CancellationToken cancellationToken = default)
        {
            var employee = await CurrentRepository.GetByIdAsync(dto.Id.Value, cancellationToken);
            if (employee == null)
                throw new UserNotFoundException();

            Mapper.Map(dto, employee);

            CurrentRepository.Update(employee);
            await UnitOfWork.SaveChangesAsync(cancellationToken);

            return Mapper.Map<EmployeeDto>(employee);
        }
    }
}
