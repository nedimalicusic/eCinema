using eCinema.Core;
using eCinema.Core.Dtos.Employee;

namespace eCinema.Application
{
    public class EmployeeProfile : BaseProfile
    {
        public EmployeeProfile()
        {
            CreateMap<EmployeeDto, Employee>().ReverseMap();

            CreateMap<EmployeeUpsertDto, Employee>();
            CreateMap<EmployeeUpsertDto, EmployeeUpsertModel>().ReverseMap();
        }
    }
}
