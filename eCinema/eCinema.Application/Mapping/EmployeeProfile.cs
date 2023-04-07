using eCinema.Core;

namespace eCinema.Application
{
    public class EmployeeProfile : BaseProfile
    {
        public EmployeeProfile()
        {
            CreateMap<EmployeeDto, Employee>().ReverseMap();

            CreateMap<EmployeeUpsertDto, Employee>();
        }
    }
}
