using eCinema.Core;
using eCinema.Core.Entities;

namespace eCinema.Application.Mapping
{
    public class WeekDayProfile : BaseProfile
    {
        public WeekDayProfile()
        {
            CreateMap<WeekDayDto, WeekDay>().ReverseMap();

            CreateMap<WeekDayUpsertDto, WeekDay>();
        }
    }
}
